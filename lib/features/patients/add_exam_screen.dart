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
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../models/patient.dart';

class AddExamScreen extends StatefulWidget {
  final Patient patient;
  const AddExamScreen({super.key, required this.patient});

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _form = GlobalKey<FormState>();
  final _vaLeft = TextEditingController();
  final _vaRight = TextEditingController();
  final _iopLeft = TextEditingController();
  final _iopRight = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_vaLeft, _vaRight, _iopLeft, _iopRight, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    HapticFeedback.lightImpact();
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);

    final exam = EyeExam(
      patientId: widget.patient.id,
      date: DateTime.now(),
      visualAcuityLeft: _vaLeft.text.trim(),
      visualAcuityRight: _vaRight.text.trim(),
      intraocularPressureLeft: _iopLeft.text.trim(),
      intraocularPressureRight: _iopRight.text.trim(),
      notes: _notes.text.trim(),
    );

    await DatabaseHelper.instance.insertExam(exam);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Add Eye Exam')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            children: [
              AdaptiveCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.cyanDim,
                      child: Text(widget.patient.initials,
                          style: const TextStyle(color: AppColors.cyan)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patient.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('Patient ID: ${widget.patient.id}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Visual Acuity', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field('OS (Left)', _vaLeft, hint: '20/20')),
                  const SizedBox(width: 12),
                  Expanded(child: _field('OD (Right)', _vaRight, hint: '20/20')),
                ],
              ),
              const SizedBox(height: 24),
              Text('Intraocular Pressure', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field('OS (Left) mmHg', _iopLeft, type: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _field('OD (Right) mmHg', _iopRight, type: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 24),
              Text('Clinical Notes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter clinical observations...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              _saving
                  ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Exam Result'),
                      onPressed: _save,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, TextInputType? type}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
