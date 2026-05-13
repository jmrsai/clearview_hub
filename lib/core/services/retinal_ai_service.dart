/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'security_service.dart';
import 'python_api_service.dart';

/// AI-powered retinal screening service using Gemini Vision multimodal API.
/// This is an educational triage tool — NOT a certified medical diagnostic.
class RetinalAiService {
  RetinalAiService._();
  static final RetinalAiService instance = RetinalAiService._();

  final ImagePicker _picker = ImagePicker();

  static const String _screeningPrompt = '''
You are an AI-assisted ophthalmic triage tool used for educational screening purposes only.
Analyze this eye photograph and provide a structured assessment.

IMPORTANT: This is NOT a certified medical diagnosis. Always recommend professional ophthalmologist consultation.

Please assess the image for visible signs of:
1. CATARACT: Look for lens opacity, clouding, grayish or white pupil appearance
2. DIABETIC RETINOPATHY: Look for hemorrhages, microaneurysms, neovascularization, exudates
3. GLAUCOMA: Look for optic disc cupping, pale optic nerve
4. AMD (Age-related Macular Degeneration): Look for drusen deposits, geographic atrophy
5. CONJUNCTIVITIS / RED EYE: Look for redness, discharge, vessel engorgement
6. NORMAL HEALTHY EYE: Clear media, normal cup-to-disc ratio, uniform color

Provide your response in this exact format:
RISK_LEVEL: [LOW / MODERATE / HIGH]
PRIMARY_FINDING: [Brief 1-line finding]
CONDITIONS_DETECTED: [Comma-separated list or "None detected"]
CONFIDENCE: [0-100]%
RECOMMENDATIONS:
- [Action 1]
- [Action 2]
- [Action 3]
DISCLAIMER: This is an AI educational triage only. Please consult a licensed ophthalmologist for professional diagnosis.
''';

  /// Capture eye image and analyze for retinal conditions.
  Future<RetinalScreeningResult?> performScreening({bool fromCamera = true}) async {
    if (!AppConfig.isGeminiConfigured) {
      return RetinalScreeningResult.error(
        'Gemini API key not configured.\n\n'
        'Edit .env → GEMINI_API_KEY=your_key_here\n'
        'Get a free key at https://aistudio.google.com',
      );
    }
    if (!RateLimitService.instance.isAllowed()) {
      return RetinalScreeningResult.error(
        'Too many AI requests. Wait ${RateLimitService.instance.secondsUntilReset}s.',
      );
    }
    try {
      final XFile? image = fromCamera
          ? await _picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 95,
              preferredCameraDevice: CameraDevice.rear,
            )
          : await _picker.pickImage(source: ImageSource.gallery, imageQuality: 95);

      if (image == null) return null;

      final bytes = await image.readAsBytes();
      return await _analyzeImage(bytes, image.path);
    } catch (e) {
      return RetinalScreeningResult.error(e.toString());
    }
  }

  Future<RetinalScreeningResult> _analyzeImage(Uint8List bytes, String imagePath) async {
    try {
      // Use the Local Python Brain (FastAPI) for processing
      final pythonApi = PythonApiService.instance;
      final response = await pythonApi.analyzeEye(imagePath);
      
      if (response['status'] == 'success') {
        final data = response['diagnostic_result'];
        return RetinalScreeningResult(
          riskLevel: data['severity_level'] > 1 ? RiskLevel.high : RiskLevel.low,
          primaryFinding: data['condition'],
          conditionsDetected: [data['condition']],
          confidence: (data['confidence'] * 100).toInt(),
          recommendations: [
            'Avoid rubbing your eyes',
            'Schedule a professional checkup if symptoms persist',
            'Maintain good digital hygiene'
          ],
          imagePath: imagePath,
          timestamp: DateTime.now(),
        );
      }
      
      // Fallback to Gemini if Python API returns error
      final model = GenerativeModel(
        model: AppConfig.geminiModel,
        apiKey: AppConfig.geminiApiKey,
      );

      final geminiResponse = await model.generateContent([
        Content.multi([
          TextPart(_screeningPrompt),
          DataPart('image/jpeg', bytes),
        ])
      ]);

      final text = geminiResponse.text ?? '';
      return RetinalScreeningResult.fromAiResponse(text, imagePath);
    } catch (e) {
      return RetinalScreeningResult.error('AI analysis failed: ${e.toString()}');
    }
  }
}

/// Result of a retinal AI screening.
class RetinalScreeningResult {
  final RiskLevel riskLevel;
  final String primaryFinding;
  final List<String> conditionsDetected;
  final int confidence;
  final List<String> recommendations;
  final String? imagePath;
  final String? error;
  final DateTime timestamp;

  RetinalScreeningResult({
    required this.riskLevel,
    required this.primaryFinding,
    required this.conditionsDetected,
    required this.confidence,
    required this.recommendations,
    this.imagePath,
    this.error,
    required this.timestamp,
  });

  factory RetinalScreeningResult.error(String msg) => RetinalScreeningResult(
    riskLevel: RiskLevel.unknown,
    primaryFinding: 'Analysis failed',
    conditionsDetected: [],
    confidence: 0,
    recommendations: ['Please try again with a clearer image'],
    error: msg,
    timestamp: DateTime.now(),
  );

  factory RetinalScreeningResult.fromAiResponse(String text, String imagePath) {
    RiskLevel risk = RiskLevel.low;
    if (text.contains('RISK_LEVEL: HIGH')) {
      risk = RiskLevel.high;
    } else if (text.contains('RISK_LEVEL: MODERATE')) {
      risk = RiskLevel.moderate;
    }

    String finding = 'No significant findings';
    final findingMatch = RegExp(r'PRIMARY_FINDING: (.+)').firstMatch(text);
    if (findingMatch != null) { finding = findingMatch.group(1) ?? finding; }

    List<String> conditions = [];
    final condMatch = RegExp(r'CONDITIONS_DETECTED: (.+)').firstMatch(text);
    if (condMatch != null) {
      final raw = condMatch.group(1) ?? '';
      if (raw.toLowerCase() != 'none detected') {
        conditions = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }
    }

    int confidence = 70;
    final confMatch = RegExp(r'CONFIDENCE: (\d+)%').firstMatch(text);
    if (confMatch != null) confidence = int.tryParse(confMatch.group(1) ?? '70') ?? 70;

    List<String> recommendations = [];
    final recoSection = RegExp(r'RECOMMENDATIONS:(.*?)DISCLAIMER:', dotAll: true).firstMatch(text);
    if (recoSection != null) {
      recommendations = recoSection.group(1)!
          .split('\n')
          .where((l) => l.trim().startsWith('-'))
          .map((l) => l.trim().replaceFirst('-', '').trim())
          .toList();
    }

    return RetinalScreeningResult(
      riskLevel: risk,
      primaryFinding: finding.trim(),
      conditionsDetected: conditions,
      confidence: confidence,
      recommendations: recommendations,
      imagePath: imagePath,
      timestamp: DateTime.now(),
    );
  }

  bool get hasError => error != null;
  Color get riskColor {
    switch (riskLevel) {
      case RiskLevel.high: return const Color(0xFFF43F5E);
      case RiskLevel.moderate: return const Color(0xFFF59E0B);
      case RiskLevel.low: return const Color(0xFF10B981);
      default: return const Color(0xFF94A3B8);
    }
  }
  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.high: return '🔴 HIGH RISK';
      case RiskLevel.moderate: return '🟡 MODERATE RISK';
      case RiskLevel.low: return '🟢 LOW RISK';
      default: return '⚪ UNKNOWN';
    }
  }
  String get riskEmoji {
    switch (riskLevel) {
      case RiskLevel.high: return '⚠️';
      case RiskLevel.moderate: return '🔶';
      case RiskLevel.low: return '✅';
      default: return '❓';
    }
  }
}

enum RiskLevel { low, moderate, high, unknown }
