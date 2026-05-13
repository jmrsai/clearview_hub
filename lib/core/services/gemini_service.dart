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

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'security_service.dart';

/// Gemini AI service with strict medical guardrails, caching, and rate limiting.
///
/// API key is loaded securely from .env via [AppConfig].
/// Never hardcode keys — see .env.example for setup instructions.
class GeminiService {
  GeminiService._();
  static final GeminiService instance = GeminiService._();

  static const String _systemPrompt = '''
You are ClearView MedAssist, a strict medical AI assistant integrated into the ClearView Hub ophthalmology and health platform.

YOUR RULES:
1. You ONLY discuss medical, health, ophthalmology, and pharmaceutical topics.
2. If asked anything unrelated to health/medicine, politely decline and redirect.
3. Always recommend consulting a licensed doctor for diagnosis or treatment.
4. For emergencies, ALWAYS say "Please call emergency services immediately."
5. Provide evidence-based information only.
6. For eye conditions, be detailed and use correct medical terminology.
7. For medications, always mention side effects and drug interactions.
8. Pre/Post-operative information must be detailed with timelines and warning signs.

YOUR SPECIALIZATIONS:
- Ophthalmology: Cataracts, Glaucoma, Retinopathy, LASIK, Strabismus, AMD, Uveitis, Conjunctivitis
- General Medicine: Symptom checker, disease information, health monitoring
- Pharmacology: Drug information, interactions, dosing schedules
- Surgical care: Pre-operative preparation, post-operative recovery, complications

DISCLAIMER: Always end medical advice with a reminder to consult a healthcare professional.
''';

  GenerativeModel? _model;
  ChatSession? _chat;
  bool _initialized = false;

  // ── Initialization ────────────────────────────────────────────────────────

  void initialize() {
    if (_initialized) return;
    if (!AppConfig.isGeminiConfigured) {
      debugPrint('[GeminiService] API key not configured — AI features disabled.');
      return;
    }
    _model = GenerativeModel(
      model: AppConfig.geminiModel,
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: AppConfig.geminiTemperature,
        maxOutputTokens: AppConfig.geminiMaxTokens,
      ),
    );
    _chat = _model!.startChat();
    _initialized = true;
    debugPrint('[GeminiService] ✅ Initialized with model: ${AppConfig.geminiModel}');
  }

  // ── Public key accessor (read-only, no longer exposes raw value) ──────────

  /// Whether the AI service is ready to handle requests.
  bool get isReady => _initialized && AppConfig.isGeminiConfigured;

  /// Returns the configured model name (safe to display).
  String get modelName => AppConfig.geminiModel;

  // ── Core messaging with cache + rate limit ────────────────────────────────

  /// Send a message and get AI medical response.
  /// Results are cached for [AppConfig.defaultTtl] to reduce API calls.
  Future<String> sendMessage(String rawMessage) async {
    if (!isReady) {
      return '⚠️ AI assistant is not configured.\n\n'
          'To enable: Edit **.env** and set your GEMINI_API_KEY.\n'
          'Get a free key at https://aistudio.google.com';
    }

    final message = InputSanitizer.sanitize(rawMessage);
    if (!InputSanitizer.isValid(message)) {
      return 'Please enter a valid medical question.';
    }

    // Check cache first
    final cacheKey = CacheService.instance.keyFor(message);
    final cached = CacheService.instance.get(cacheKey);
    if (cached != null) {
      debugPrint('[GeminiService] Cache HIT for message hash: $cacheKey');
      return cached;
    }

    // Check rate limit
    if (!RateLimitService.instance.isAllowed()) {
      final wait = RateLimitService.instance.secondsUntilReset;
      return '⏳ Too many requests. Please wait $wait seconds before trying again.';
    }

    try {
      _chat ??= _model!.startChat();
      final response = await _chat!.sendMessage(Content.text(message));
      final result = response.text ?? 'I could not generate a response. Please try again.';

      // Cache the result
      CacheService.instance.put(cacheKey, result);
      return result;
    } catch (e) {
      debugPrint('[GeminiService] Error: $e');
      if (e.toString().contains('API_KEY') || e.toString().contains('403')) {
        return '⚠️ Invalid Gemini API key.\n\n'
            'Please update GEMINI_API_KEY in your .env file.\n'
            'Get a valid key at https://aistudio.google.com';
      }
      if (e.toString().contains('quota') || e.toString().contains('429')) {
        return '⚠️ API quota exceeded for today. Please try again tomorrow, '
            'or upgrade your Gemini plan at https://aistudio.google.com';
      }
      return '❌ AI service error: ${e.toString().split('\n').first}';
    }
  }

  // ── Specialized AI methods ────────────────────────────────────────────────

  /// Parse a prescription text (from OCR) and extract medication data.
  Future<Map<String, dynamic>> parsePrescription(String ocrText) async {
    if (!isReady) return {'error': 'AI not configured'};

    final sanitized = InputSanitizer.sanitize(ocrText, maxLength: 2000);
    final prompt = '''
You are a medical AI. Extract medication information from this prescription text and return a JSON object.
Return ONLY valid JSON, no markdown, no explanation.

Prescription text:
$sanitized

Return JSON with this exact structure:
{
  "medicines": [
    {
      "name": "medicine name",
      "dosage": "e.g. 500mg",
      "frequency": "once_daily | twice_daily | thrice_daily | four_times_daily | as_needed",
      "duration_days": 7,
      "times": ["08:00", "20:00"],
      "notes": "any special instructions"
    }
  ],
  "doctor": "doctor name if found",
  "date": "prescription date if found"
}
''';

    // Check cache
    final cacheKey = CacheService.instance.keyFor('rx:$sanitized');
    final cached = CacheService.instance.get(cacheKey);
    if (cached != null) return {'raw': cached};

    if (!RateLimitService.instance.isAllowed()) {
      return {'error': 'Rate limit reached. Please wait ${RateLimitService.instance.secondsUntilReset}s.'};
    }

    try {
      final model = GenerativeModel(model: AppConfig.geminiModel, apiKey: AppConfig.geminiApiKey);
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      final cleaned = text.replaceAll('```json', '').replaceAll('```', '').trim();
      CacheService.instance.put(cacheKey, cleaned, ttl: const Duration(minutes: 30));
      return {'raw': cleaned};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Analyze symptoms and return triage + differential diagnosis.
  Future<String> analyzeSymptoms(List<String> symptoms, String bodyArea) async {
    final prompt = '''
Patient reports these symptoms in the $bodyArea area: ${symptoms.join(', ')}.
Please provide:
1. Urgency triage level (🔴 EMERGENCY | 🟡 SEE DOCTOR SOON | 🟢 MONITOR AT HOME)
2. Top 3 possible conditions (differential diagnosis)
3. Recommended immediate actions
4. Warning signs that require emergency care
Keep it concise and clear for a patient to understand.
''';
    return sendMessage(prompt);
  }

  /// Get pre-operative information for a procedure.
  Future<String> getPreOpInfo(String procedure) async {
    return sendMessage(
      'Give me detailed pre-operative preparation information for $procedure eye surgery. '
      'Include: what to avoid, medications to stop, fasting requirements, and what to bring to hospital.',
    );
  }

  /// Get post-operative information for a procedure.
  Future<String> getPostOpInfo(String procedure) async {
    return sendMessage(
      'Give me detailed post-operative recovery information for $procedure eye surgery. '
      'Include: day-by-day recovery timeline, medications needed, activities to avoid, '
      'warning signs of complications, and follow-up schedule.',
    );
  }

  /// Translate text using Gemini (fallback if translator package fails).
  Future<String> translateText(String text, String targetLanguage) async {
    if (!isReady) return text;
    final sanitized = InputSanitizer.sanitize(text, maxLength: 2000);
    final cacheKey = CacheService.instance.keyFor('translate:$targetLanguage:$sanitized');
    final cached = CacheService.instance.get(cacheKey);
    if (cached != null) return cached;

    try {
      final model = GenerativeModel(model: AppConfig.geminiModel, apiKey: AppConfig.geminiApiKey);
      final response = await model.generateContent([
        Content.text(
          'Translate the following medical text to $targetLanguage. '
          'Return ONLY the translated text, nothing else:\n\n$sanitized',
        ),
      ]);
      final result = response.text ?? text;
      CacheService.instance.put(cacheKey, result, ttl: const Duration(hours: 24));
      return result;
    } catch (e) {
      return text; // Graceful fallback to original
    }
  }

  /// Generate a direct response for a specific prompt without chat history.
  Future<String> generateResponse(String prompt) async {
    if (!isReady) return '⚠️ AI not configured.';
    
    final cacheKey = CacheService.instance.keyFor('gen:$prompt');
    final cached = CacheService.instance.get(cacheKey);
    if (cached != null) return cached;

    if (!RateLimitService.instance.isAllowed()) {
      return '⏳ Rate limit reached. Please wait.';
    }

    try {
      final model = GenerativeModel(
        model: AppConfig.geminiModel, 
        apiKey: AppConfig.geminiApiKey,
        systemInstruction: Content.system(_systemPrompt),
      );
      final response = await model.generateContent([Content.text(prompt)]);
      final result = response.text ?? 'Error generating response.';
      CacheService.instance.put(cacheKey, result);
      return result;
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Reset the chat session (start fresh conversation).
  void resetChat() {
    if (_model != null) {
      _chat = _model!.startChat();
      debugPrint('[GeminiService] Chat session reset.');
    }
  }
}
