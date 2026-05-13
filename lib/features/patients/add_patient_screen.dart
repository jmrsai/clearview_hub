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
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../models/patient.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/auth_service.dart';

class AddPatientScreen extends StatefulWidget {
  final VoidCallback? onSaved;
  const AddPatientScreen({super.key, this.onSaved});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _mrn = TextEditingController();
  final _diag = TextEditingController();
  final _allergy = TextEditingController();
  String _gender = 'Male';
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _age, _email, _phone, _mrn, _diag, _allergy]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    HapticFeedback.lightImpact();
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);

    final patient = Patient(
      id: 'P-${const Uuid().v4().substring(0, 6).toUpperCase()}',
      name: _name.text.trim(),
      age: int.parse(_age.text.trim()),
      gender: _gender,
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      medicalRecordNumber: _mrn.text.trim().isEmpty ? null : _mrn.text.trim(),
      diagnosis: _diag.text.trim().isEmpty ? null : _diag.text.trim(),
      allergies: _allergy.text.trim().isEmpty ? null : _allergy.text.trim(),
    );

    await DatabaseHelper.instance.insertPatient(patient);

    // Cloud Sync
    if (AuthService.instance.isAuthenticated) {
      try {
        await FirestoreService.instance.savePatient(patient);
      } catch (e) {
        debugPrint('Cloud sync failed: $e');
      }
    }

    if (mounted) {
      widget.onSaved?.call();
      Navigator.pop(context, patient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            children: [
              Text('Demographics', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _field('Full Name', _name, icon: Icons.person_outline,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _field('Age', _age,
                          icon: Icons.cake_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            return n == null || n < 0 || n > 120 ? 'Invalid age' : null;
                          })),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.wc)),
                      dropdownColor: AppColors.bgCard,
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (v) => setState(() => _gender = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Contact & Medical', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _field('Email', _email, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _field('Phone', _phone, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _field('Medical Record Number', _mrn, icon: Icons.badge_outlined),
              const SizedBox(height: 12),
              _field('Primary Diagnosis', _diag, icon: Icons.medical_information_outlined),
              const SizedBox(height: 12),
              _field('Known Allergies', _allergy, icon: Icons.warning_amber_outlined),
              const SizedBox(height: 32),
              _saving
                  ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Complete Registration'),
                      onPressed: _save,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {IconData? icon, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
