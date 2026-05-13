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
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../core/services/notification_service.dart';
import '../../models/medication_log.dart';

class MedicationLogScreen extends StatefulWidget {
  final String patientId;
  const MedicationLogScreen({super.key, required this.patientId});
  @override
  State<MedicationLogScreen> createState() => _MedicationLogScreenState();
}

class _MedicationLogScreenState extends State<MedicationLogScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, int> _compliance = {};
  List<MedicationLog> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    final compliance = await db.getMedicationComplianceMap(widget.patientId);
    final logs = await db.getMedicationLogsForPatient(widget.patientId);
    if (mounted) setState(() { _compliance = compliance; _logs = logs; _loading = false; });
  }

  List<MedicationLog> _logsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _logs.where((l) {
      final d = l.scheduledAt;
      return d.year == key.year && d.month == key.month && d.day == key.day;
    }).toList();
  }

  Future<void> _markTaken(MedicationLog log) async {
    final updated = log.copyWith(status: 'taken', takenAt: DateTime.now());
    await DatabaseHelper.instance.updateMedicationLog(updated);
    _load();
  }

  Future<void> _addMedication() async {
    final nameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    TimeOfDay time = TimeOfDay.now();

    await showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Medication', style: TextStyle(color: AppColors.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Medication Name')),
        const SizedBox(height: 12),
        TextField(controller: doseCtrl,
            decoration: const InputDecoration(labelText: 'Dosage (e.g. 1 drop)')),
        const SizedBox(height: 12),
        ListTile(contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.access_time, color: AppColors.cyan),
          title: Text('Reminder: ${time.format(ctx)}',
              style: const TextStyle(color: AppColors.textPrimary)),
          onTap: () async {
            HapticFeedback.lightImpact();
            final picked = await showTimePicker(context: ctx, initialTime: time);
            if (picked != null) time = picked;
          },
        ),
      ]),
      actions: [
        TextButton(onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(ctx);
        }, child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
          onPressed: () async {
            HapticFeedback.lightImpact();
            if (nameCtrl.text.trim().isEmpty) return;
            final now = DateTime.now();
            final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
            final log = MedicationLog(
              patientId: widget.patientId,
              medicationName: nameCtrl.text.trim(),
              dosage: doseCtrl.text.trim().isEmpty ? '1 dose' : doseCtrl.text.trim(),
              frequency: 'daily',
              scheduledAt: scheduled,
            );
            await DatabaseHelper.instance.insertMedicationLog(log);
            await NotificationService.instance.scheduleDailyMedicationReminder(
              id: log.hashCode,
              medicationName: log.medicationName,
              dosage: log.dosage,
              hour: time.hour,
              minute: time.minute,
            );
            if (ctx.mounted) {
              Navigator.pop(ctx);
            }
            _load();
          },
          child: const Text('Add'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Medication Log'),
        actions: [
          IconButton(icon: const Icon(Icons.add, color: AppColors.cyan), onPressed: () {
            HapticFeedback.lightImpact();
            _addMedication();
          }),
        ],
      ),
      body: SafeArea(child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : Column(children: [
              // Calendar
              Padding(padding: const EdgeInsets.fromLTRB(12, 60, 12, 0),
                child: AdaptiveCard(padding: const EdgeInsets.all(8), child: TableCalendar(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2030),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (d) => isSameDay(_selectedDay, d),
                  onDaySelected: (selected, focused) =>
                      setState(() { 
                        HapticFeedback.lightImpact();
                        _selectedDay = selected; 
                        _focusedDay = focused; 
                      }),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
                    weekendTextStyle: const TextStyle(color: AppColors.textSecondary),
                    selectedDecoration: const BoxDecoration(
                        color: AppColors.cyan, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppColors.cyanDim, shape: BoxShape.circle),
                    markerDecoration: const BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                    leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textPrimary),
                    rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  ),
                  eventLoader: (day) {
                    final key = DateTime(day.year, day.month, day.day);
                    return List.generate(_compliance[key] ?? 0, (_) => true);
                  },
                )),
              ),
              const SizedBox(height: 12),
              // Day's logs
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Text('${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Text('${_logsForDay(_selectedDay).length} medications',
                      style: Theme.of(context).textTheme.bodyMedium),
                ]),
              ),
              const SizedBox(height: 8),
              Expanded(child: _logsForDay(_selectedDay).isEmpty
                  ? Center(child: Text('No medications for this day',
                      style: Theme.of(context).textTheme.bodyMedium))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _logsForDay(_selectedDay).length,
                      separatorBuilder: (_, index) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final log = _logsForDay(_selectedDay)[i];
                        final color = log.isTaken ? AppColors.success
                            : log.isMissed ? AppColors.error : AppColors.warning;
                        return AdaptiveCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Row(children: [
                            Icon(log.isTaken ? Icons.check_circle_outline : Icons.circle_outlined,
                                color: color, size: 26),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(log.medicationName,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text('${log.dosage}  ·  ${_time(log.scheduledAt)}',
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ])),
                            if (!log.isTaken)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(70, 36),
                                    backgroundColor: AppColors.success),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _markTaken(log);
                                },
                                child: const Text('Taken', style: TextStyle(fontSize: 12)),
                              ),
                            if (log.isTaken)
                              const Text('✓ Done', style: TextStyle(
                                  color: AppColors.success, fontWeight: FontWeight.w700)),
                          ]),
                        );
                      },
                    )),
            ])),
    );
  }

  String _time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
}
