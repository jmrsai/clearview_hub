import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../widgets/glass_card.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({super.key});

  @override
  State<MedicationTrackerScreen> createState() => _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Artificial Tears',
      'dosage': '1 drop, both eyes',
      'frequency': 'Every 4 hours',
      'icon': Icons.water_drop,
      'color': Colors.blueAccent,
      'taken': false,
    },
    {
      'name': 'Latanoprost (Glaucoma)',
      'dosage': '1 drop, right eye',
      'frequency': 'Once daily (Evening)',
      'icon': Icons.medication,
      'color': Colors.purpleAccent,
      'taken': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Medication & Eye Drops'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Prescriptions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  final med = _medications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: med['color'].withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(med['icon'], color: med['color']),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  med['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  med['dosage'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  med['frequency'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: med['taken'],
                            activeColor: Colors.cyanAccent,
                            checkColor: Colors.black,
                            onChanged: (val) {
                              setState(() {
                                med['taken'] = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        onPressed: () {
          // Add medication logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Medication feature coming soon!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Eye Drop'),
      ),
    );
  }
}
