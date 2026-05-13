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

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/gemini_service.dart';
import '../../core/config/app_config.dart';

class MedicalDocumentScanner extends StatefulWidget {
  const MedicalDocumentScanner({super.key});

  @override
  State<MedicalDocumentScanner> createState() => _MedicalDocumentScannerState();
}

class _MedicalDocumentScannerState extends State<MedicalDocumentScanner> {
  File? _imageFile;
  bool _isProcessing = false;
  String _rawText = '';
  String _structuredData = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isProcessing = true;
        _rawText = '';
        _structuredData = '';
      });
      await _processImage(_imageFile!);
    }
  }

  Future<void> _processImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      setState(() {
        _rawText = recognizedText.text;
      });

      textRecognizer.close();

      if (_rawText.isNotEmpty && AppConfig.isGeminiConfigured) {
        // Send to Gemini to structure
        final prompt = "You are a medical data extractor. I will provide raw OCR text from a medical document. Extract the key entities (Patient Name, Date, Vital Signs, Diagnosis, Prescriptions, Doctor's Notes) into a clean, structured Markdown format.\n\nRaw Text:\n$_rawText";
        final response = await GeminiService.instance.generateResponse(prompt);
        setState(() {
          _structuredData = response;
        });
      } else if (!AppConfig.isGeminiConfigured) {
         setState(() {
          _structuredData = "⚠️ Gemini API key not configured. Raw text extracted but cannot be structured.";
        });
      }
    } catch (e) {
      setState(() {
        _rawText = 'Error reading text: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Medical Document OCR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Take a photo of a medical record to digitize and extract structured data.')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null)
              AdaptiveCard(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _imageFile!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              AdaptiveCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.document_scanner, size: 64, color: AppColors.cyan.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'No Document Selected',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the camera or gallery to scan a clinical record.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    onPressed: _isProcessing ? null : () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    onPressed: _isProcessing ? null : () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            if (_isProcessing)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.cyan),
                    SizedBox(height: 16),
                    Text('Extracting and analyzing medical data...', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            
            if (!_isProcessing && _structuredData.isNotEmpty) ...[
              Text('AI Extracted Data', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              AdaptiveCard(
                child: Text(
                  _structuredData,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            if (!_isProcessing && _rawText.isNotEmpty) ...[
              Text('Raw OCR Output', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AdaptiveCard(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _rawText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace', color: AppColors.textHint),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
