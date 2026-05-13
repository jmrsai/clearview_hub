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
import '../../core/services/ocr_service.dart';
import '../../core/services/medication_reminder_service.dart';
import '../../core/theme/app_colors.dart';

class PrescriptionScannerScreen extends StatefulWidget {
  const PrescriptionScannerScreen({super.key});
  @override
  State<PrescriptionScannerScreen> createState() => _PrescriptionScannerScreenState();
}

class _PrescriptionScannerScreenState extends State<PrescriptionScannerScreen> {
  bool _scanning = false;
  OcrResult? _result;
  String? _error;

  Future<void> _scan({bool fromCamera = true}) async {
    setState(() { _scanning = true; _result = null; _error = null; });
    HapticFeedback.mediumImpact();

    try {
      final result = await OcrService.instance.scanPrescription(fromCamera: fromCamera);
      setState(() {
        _scanning = false;
        if (result == null) {
          _error = 'Scan cancelled.';
        } else if (result.hasError) {
          _error = result.error;
        } else {
          _result = result;
        }
      });
    } catch (e) {
      setState(() { _scanning = false; _error = e.toString(); });
    }
  }

  Future<void> _addAllReminders() async {
    if (_result == null) return;
    for (final med in _result!.parsedMedicines) {
      final reminder = MedicationReminder(
        id: const Uuid().v4(),
        medicineName: med.name,
        dosage: med.dosage,
        frequency: med.frequency,
        times: med.defaultTimes,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: med.durationDays)),
      );
      await MedicationReminderService.instance.scheduleReminder(reminder);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${_result!.parsedMedicines.length} reminder(s) set with alarms!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('Scan Prescription', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Hero Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const Icon(Icons.document_scanner, size: 56, color: Colors.white),
              const SizedBox(height: 16),
              const Text('Prescription Scanner', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Point your camera at a prescription and AI will automatically extract medicines, dosages, and set reminders.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _scanning ? null : () => _scan(fromCamera: true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0EA5E9)),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _scanning ? null : () => _scan(fromCamera: false),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // Loading state
          if (_scanning)
            Column(children: [
              const CircularProgressIndicator(color: AppColors.cyan),
              const SizedBox(height: 16),
              Text('Scanning prescription with AI...', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Text('This may take a few seconds', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            ]),

          // Error state
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.error.withAlpha(20), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.error_outline, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error))),
              ]),
            ),

          // OCR Results
          if (_result != null && !_result!.hasError) ...[
            if (_result!.doctorName != null) ...[
              Row(children: [
                const Icon(Icons.person, color: AppColors.cyan, size: 16),
                const SizedBox(width: 8),
                Text('Dr. ${_result!.doctorName}', style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w600)),
                if (_result!.prescriptionDate != null) ...[
                  const Spacer(),
                  Text(_result!.prescriptionDate!, style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                ],
              ]),
              const SizedBox(height: 14),
            ],

            if (_result!.parsedMedicines.isNotEmpty) ...[
              Row(children: [
                const Icon(Icons.medication, color: Colors.white),
                const SizedBox(width: 8),
                Text('${_result!.parsedMedicines.length} Medicine(s) Found',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 14),
              ..._result!.parsedMedicines.map((med) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cyan.withAlpha(40)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(med.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(children: [
                    _Chip('💊 ${med.dosage}', AppColors.cyan),
                    const SizedBox(width: 8),
                    _Chip('🕐 ${med.frequency.replaceAll('_', ' ')}', AppColors.violet),
                    const SizedBox(width: 8),
                    _Chip('📅 ${med.durationDays}d', AppColors.teal),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.alarm, size: 14, color: AppColors.textHint),
                    const SizedBox(width: 6),
                    Text('Alarms: ${med.defaultTimes.join(' · ')}',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ]),
                ]),
              )),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addAllReminders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(double.infinity, 56),
                ),
                icon: const Icon(Icons.alarm_add, color: Colors.white),
                label: const Text('Set All Alarms & Reminders',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ] else ...[
              const Text('No medicines could be extracted. Please try again with a clearer image.',
                  style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],

            // Raw OCR text (expandable)
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text('Raw OCR Text', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
              iconColor: AppColors.textHint,
              collapsedIconColor: AppColors.textHint,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(8)),
                  child: Text(_result!.rawText, style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'monospace')),
                ),
              ],
            ),
          ],
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}
