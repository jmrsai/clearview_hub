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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/patient.dart';
import '../../core/services/gemini_service.dart';
import '../../core/database/database_helper.dart';
import '../../core/config/app_config.dart';

class AiPatientSummaryScreen extends StatefulWidget {
  final Patient patient;

  const AiPatientSummaryScreen({super.key, required this.patient});

  @override
  State<AiPatientSummaryScreen> createState() => _AiPatientSummaryScreenState();
}

class _AiPatientSummaryScreenState extends State<AiPatientSummaryScreen> {
  bool _isLoading = true;
  String _summary = '';
  String _error = '';

  @override
  void initState() {
    super.initState();
    _generateSummary();
  }

  Future<void> _generateSummary() async {
    if (!AppConfig.isGeminiConfigured) {
      if (mounted) {
        setState(() {
          _error = 'Gemini API key is not configured. Please configure it in Settings.';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final db = DatabaseHelper.instance;
      final exams = await db.getExamsForPatient(widget.patient.id);
      final tests = await db.getVisionTestsForPatient(widget.patient.id);
      
      String prompt = '''
You are an expert ophthalmologist AI. Summarize the following patient history into a concise, professional clinical summary. 
Provide a "Current Status", "Key Observations", and "Recommendations". Keep it brief (under 150 words).

Patient Name: ${widget.patient.name}
Age: ${widget.patient.age}
Gender: ${widget.patient.gender}
Diagnosis: ${widget.patient.diagnosis ?? 'None'}

Recent Exams:
${exams.take(3).map((e) => '- ${e.date.toIso8601String()}: VA L:${e.visualAcuityLeft} R:${e.visualAcuityRight}, IOP L:${e.intraocularPressureLeft} R:${e.intraocularPressureRight}. Notes: ${e.notes}').join('\n')}

Recent Vision Tests:
${tests.take(3).map((t) => '- ${t.testType} on ${t.performedAt.toIso8601String()}: L:${t.acuityLeft} R:${t.acuityRight}').join('\n')}
''';

      final response = await GeminiService.instance.generateResponse(prompt);
      
      if (mounted) {
        setState(() {
          _summary = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate summary: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('AI Patient Summary'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdaptiveCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.cyanDim,
                      child: const Icon(Icons.auto_awesome, color: AppColors.cyan, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Clinical Summary', style: Theme.of(context).textTheme.titleLarge),
                          Text('For ${widget.patient.name}', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: AdaptiveCard(
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppColors.violet),
                              SizedBox(height: 16),
                              Text('Synthesizing medical history...'),
                            ],
                          ),
                        )
                      : _error.isNotEmpty
                          ? Center(
                              child: Text(_error, style: const TextStyle(color: AppColors.error)),
                            )
                          : SingleChildScrollView(
                              child: Text(
                                _summary,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
