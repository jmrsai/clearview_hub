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
import 'package:uuid/uuid.dart';
import '../../core/services/medication_reminder_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'prescription_scanner_screen.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});
  @override
  State<MedicationReminderScreen> createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {

  @override
  void initState() {
    super.initState();
    MedicationReminderService.instance.initialize();
  }

  void _openScanner() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrescriptionScannerScreen()));
  }

  void _addManually() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10142A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _AddReminderSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('Medication Reminders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner, color: AppColors.cyan),
            onPressed: _openScanner,
            tooltip: 'Scan Prescription',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'scan',
            backgroundColor: AppColors.cyan,
            onPressed: _openScanner,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'add',
            backgroundColor: AppColors.violet,
            onPressed: _addManually,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Manually', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder<List<MedicationReminder>>(
        stream: MedicationReminderService.instance.getReminders(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cyan));
          }
          final reminders = snap.data ?? [];
          if (reminders.isEmpty) {
            return _EmptyState(onScan: _openScanner, onAdd: _addManually);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: reminders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ReminderCard(reminder: reminders[i]),
          );
        },
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final MedicationReminder reminder;
  const _ReminderCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.cyanDim, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication, color: AppColors.cyan, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(reminder.medicineName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
            Text(reminder.dosage, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: reminder.isActive ? AppColors.success.withAlpha(30) : AppColors.error.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reminder.isActive ? 'Active' : 'Paused',
              style: TextStyle(
                color: reminder.isActive ? AppColors.success : AppColors.error,
                fontSize: 12, fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          const Icon(Icons.schedule, size: 14, color: AppColors.textHint),
          const SizedBox(width: 6),
          Text(reminder.frequencyLabel, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const Spacer(),
          ...reminder.times.map((t) => Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(8)),
            child: Text(t, style: const TextStyle(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.w600)),
          )),
        ]),
        if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(reminder.notes!, style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        ],
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => MedicationReminderService.instance.markTaken(reminder.id),
              icon: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              label: const Text('Mark Taken', style: TextStyle(color: AppColors.success, fontSize: 13)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.success)),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => MedicationReminderService.instance.cancelReminder(reminder.id),
          ),
        ]),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onScan;
  final VoidCallback onAdd;
  const _EmptyState({required this.onScan, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: AppColors.cyanDim, shape: BoxShape.circle),
            child: const Icon(Icons.medication_outlined, size: 60, color: AppColors.cyan),
          ),
          const SizedBox(height: 24),
          const Text('No Medication Reminders', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text('Scan your prescription to auto-create reminders, or add them manually.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onScan,
            icon: const Icon(Icons.document_scanner),
            label: const Text('Scan Prescription'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Manually'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ]),
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet();
  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _frequency = 'once_daily';
  List<String> _times = ['08:00'];
  bool _saving = false;

  final _freqOptions = [
    ('once_daily', 'Once daily', ['08:00']),
    ('twice_daily', 'Twice daily', ['08:00', '20:00']),
    ('thrice_daily', 'Three times daily', ['08:00', '14:00', '20:00']),
    ('four_times_daily', 'Four times daily', ['08:00', '12:00', '16:00', '20:00']),
  ];

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _dosageCtrl.text.isEmpty) return;
    setState(() => _saving = true);

    final reminder = MedicationReminder(
      id: const Uuid().v4(),
      medicineName: _nameCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim(),
      frequency: _frequency,
      times: _times,
      startDate: DateTime.now(),
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
    );

    await MedicationReminderService.instance.scheduleReminder(reminder);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Add Medication Reminder', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        TextField(
          controller: _nameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Medicine Name', prefixIcon: Icon(Icons.medication)),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _dosageCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Dosage (e.g. 500mg)', prefixIcon: Icon(Icons.scale)),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _frequency,
          dropdownColor: const Color(0xFF1E2235),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Frequency', prefixIcon: Icon(Icons.repeat)),
          items: _freqOptions.map((f) => DropdownMenuItem(value: f.$1, child: Text(f.$2))).toList(),
          onChanged: (v) {
            if (v == null) return;
            final opt = _freqOptions.firstWhere((f) => f.$1 == v);
            setState(() { _frequency = v; _times = opt.$3; });
          },
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _notesCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Notes (optional)', prefixIcon: Icon(Icons.notes)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, minimumSize: const Size(double.infinity, 50)),
          child: _saving
              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : const Text('Set Alarm & Save', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
