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
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/translator_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/python_api_service.dart';
import '../ai_assistant/gemini_chat_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});
  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final Set<String> _selectedSymptoms = {};
  String _selectedArea = 'Eye';
  String? _result;
  bool _loading = false;
  TriageLevel? _triageLevel;

  static const Map<String, List<String>> _symptomsByArea = {
    'Eye': [
      'Blurry vision', 'Double vision', 'Eye pain', 'Red eyes', 'Eye discharge',
      'Floaters', 'Flashes of light', 'Loss of peripheral vision', 'Halos around lights',
      'Dry eyes', 'Watery eyes', 'Sensitivity to light', 'Eye swelling', 'Itchy eyes',
      'Night blindness', 'Color vision changes', 'Sudden vision loss',
    ],
    'Head': [
      'Headache', 'Migraine', 'Pressure behind eyes', 'Temple pain', 'Forehead pain',
    ],
    'General': [
      'Fever', 'Fatigue', 'Nausea', 'Dizziness', 'Weakness', 'Weight loss',
    ],
    'Neurological': [
      'Numbness', 'Drooping eyelid', 'Facial weakness', 'Confusion', 'Memory issues',
    ],
  };

  static const List<String> _bodyAreas = ['Eye', 'Head', 'General', 'Neurological'];

  Future<void> _analyze() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }

    setState(() { _loading = true; _result = null; _triageLevel = null; });
    HapticFeedback.mediumImpact();

    // Call Python FastAPI
    final message = "I have symptoms in my $_selectedArea. The symptoms are: ${_selectedSymptoms.join(', ')}.";
    final res = await PythonApiService.instance.chatMedical(message);
    
    final translated = await TranslatorService.instance.translate(res['response']);

    TriageLevel level = TriageLevel.monitor;
    if (res['is_emergency'] == true || translated.contains('EMERGENCY') || translated.contains('🚨')) {
      level = TriageLevel.emergency;
    } else if (translated.contains('SEE DOCTOR') || translated.contains('🏥')) {
      level = TriageLevel.seeDoctor;
    }

    if (mounted) setState(() { _result = translated; _loading = false; _triageLevel = level; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('Symptom Checker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Area selector
          const Text('Select Body Area', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _bodyAreas.map((area) => ChoiceChip(
              label: Text(area),
              selected: _selectedArea == area,
              selectedColor: AppColors.cyan,
              labelStyle: TextStyle(color: _selectedArea == area ? Colors.white : AppColors.textSecondary),
              backgroundColor: const Color(0xFF1E2235),
              onSelected: (_) => setState(() { _selectedArea = area; _selectedSymptoms.clear(); }),
            )).toList(),
          ),
          const SizedBox(height: 24),

          // Symptoms grid
          const Text('Select Your Symptoms', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_symptomsByArea[_selectedArea] ?? []).map((symptom) {
              final sel = _selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Text(symptom, style: TextStyle(color: sel ? Colors.white : AppColors.textSecondary, fontSize: 13)),
                selected: sel,
                selectedColor: AppColors.violet,
                backgroundColor: const Color(0xFF1E2235),
                checkmarkColor: Colors.white,
                onSelected: (v) => setState(() => v ? _selectedSymptoms.add(symptom) : _selectedSymptoms.remove(symptom)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Selected count
          if (_selectedSymptoms.isNotEmpty)
            Text('${_selectedSymptoms.length} symptom(s) selected', style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w600)),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _analyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.violet,
              minimumSize: const Size(double.infinity, 54),
            ),
            icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.search),
            label: Text(_loading ? 'Analyzing...' : 'Analyze Symptoms with AI', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),

          // Results
          if (_result != null) ...[
            const SizedBox(height: 24),
            _TriageCard(level: _triageLevel ?? TriageLevel.monitor),
            const SizedBox(height: 16),
            AdaptiveCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.medical_information, color: AppColors.cyan, size: 18),
                  SizedBox(width: 8),
                  Text('AI Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ]),
                const SizedBox(height: 14),
                Text(_result!, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GeminiChatScreen(
                      initialPrompt: 'I have these symptoms: ${_selectedSymptoms.join(', ')}. Can you help me understand them?',
                    ),
                  )),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Discuss with AI Doctor'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                ),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

enum TriageLevel { emergency, seeDoctor, monitor }

class _TriageCard extends StatelessWidget {
  final TriageLevel level;
  const _TriageCard({required this.level});

  @override
  Widget build(BuildContext context) {
    final (emoji, title, subtitle, color) = switch (level) {
      TriageLevel.emergency => ('🚨', 'EMERGENCY', 'Seek immediate medical attention or call emergency services.', AppColors.error),
      TriageLevel.seeDoctor => ('🏥', 'SEE DOCTOR SOON', 'Visit a doctor within 24–48 hours for proper evaluation.', AppColors.warning),
      TriageLevel.monitor => ('✅', 'MONITOR AT HOME', 'Your symptoms appear manageable. Monitor and see a doctor if they worsen.', AppColors.success),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: color.withAlpha(200), fontSize: 12, height: 1.4)),
        ])),
      ]),
    );
  }
}
