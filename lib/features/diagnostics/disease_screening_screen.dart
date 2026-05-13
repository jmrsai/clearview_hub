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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/ai_diagnostic_service.dart';
import '../../core/widgets/instruction_modal.dart';

import '../../models/vision_test_result.dart';
import '../../core/database/database_helper.dart';

class DiseaseScreeningScreen extends StatefulWidget {
  final String patientId;
  const DiseaseScreeningScreen({super.key, required this.patientId});

  @override
  State<DiseaseScreeningScreen> createState() => _DiseaseScreeningScreenState();
}

class _DiseaseScreeningScreenState extends State<DiseaseScreeningScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isAnalyzing = false;
  DiagnosticResult? _result;

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (ctx) => InstructionModal(
        title: 'AI Eye Screening',
        steps: const [
          'Ensure you are in a well-lit environment.',
          'Remove glasses or contact lenses if possible.',
          'Align the eye clearly within the camera frame.',
          'Hold the phone steady to avoid blurring.',
          'The AI will analyze the image for signs of Cataract, Glaucoma, or Retinopathy.',
        ],
        onStart: _captureImage,
      ),
    );
  }

  Future<void> _captureImage() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo != null) {
      setState(() {
        _imageFile = photo;
        _result = null;
      });
      _runAnalysis();
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _imageFile = image;
        _result = null;
      });
      _runAnalysis();
    }
  }

  Future<void> _runAnalysis() async {
    if (_imageFile == null) return;
    setState(() => _isAnalyzing = true);

    try {
      final result = await AiDiagnosticService.instance.analyzeEyeImage(_imageFile!.path);
      
      // Save result to database
      await DatabaseHelper.instance.insertVisionTestResult(VisionTestResult(
        patientId: widget.patientId,
        testType: 'ai_screening',
        performedAt: DateTime.now(),
        notes: 'Condition: ${result.conditionLabel}, Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
      ));

      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Disease Screening')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: AdaptiveCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _imageFile == null
                        ? _buildPlaceholder()
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                              if (_isAnalyzing)
                                Container(
                                  color: Colors.black45,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(color: AppColors.cyan),
                                      SizedBox(height: 16),
                                      Text('AI Analyzing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_result != null) _buildResultCard(),
              const SizedBox(height: 24),
              if (!_isAnalyzing)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showInstructions();
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Capture Eye'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _pickFromGallery();
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_red_eye, size: 64, color: AppColors.cyanDim.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('No Image Captured', style: TextStyle(color: AppColors.textHint)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Capture a high-quality photo of the eye for AI-powered disease screening.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final Color resultColor = _result!.condition == EyeCondition.normal 
        ? AppColors.success 
        : (_result!.confidence > 0.8 ? AppColors.error : AppColors.warning);

    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AI Analysis Result', style: Theme.of(context).textTheme.titleMedium),
              Chip(
                label: Text('${(_result!.confidence * 100).toStringAsFixed(1)}% Conf.'),
                backgroundColor: resultColor.withValues(alpha: 0.2),
                labelStyle: TextStyle(color: resultColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _result!.conditionLabel,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: resultColor),
          ),
          const SizedBox(height: 8),
          Text(
            _result!.condition == EyeCondition.normal
                ? 'The AI suggests your eye health is normal. Continue regular checkups.'
                : 'Potential signs of ${_result!.conditionLabel} detected. Please consult an ophthalmologist for a formal diagnosis.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
