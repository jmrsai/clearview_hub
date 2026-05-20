import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/medication_reminder.dart';

class MedicationSchedulerScreen extends StatelessWidget {
  MedicationSchedulerScreen({super.key});

  final List<MedicationReminder> _mockReminders = [
    MedicationReminder(
      id: '1',
      medicationName: 'Artificial Tears',
      dosage: '1 drop in each eye',
      time: DateTime(2026, 5, 15, 8, 0),
    ),
    MedicationReminder(
      id: '2',
      medicationName: 'Glaucoma Drops',
      dosage: '1 drop in left eye',
      time: DateTime(2026, 5, 15, 20, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_alarm),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.insights,
                  color: AppColors.secondary,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adherence Score: 92%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'You haven\'t missed any doses this week!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockReminders.length,
              itemBuilder: (context, index) {
                final reminder = _mockReminders[index];
                return Card(
                  color: Colors.white.withValues(alpha: 0.05),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.water_drop, color: AppColors.accent),
                    ),
                    title: Text(
                      reminder.medicationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${reminder.dosage} • ${reminder.time.hour}:${reminder.time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Switch(
                      value: reminder.isActive,
                      onChanged: (val) {},
                      activeTrackColor: AppColors.accent,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
