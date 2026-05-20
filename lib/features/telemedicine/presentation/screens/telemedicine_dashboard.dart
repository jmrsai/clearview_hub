import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/doctor.dart';

class TelemedicineDashboard extends StatelessWidget {
  TelemedicineDashboard({super.key});

  final List<Doctor> _mockDoctors = [
    const Doctor(
      id: '1',
      name: 'Dr. Sarah Wilson',
      specialty: 'Ophthalmologist (Cataract Specialist)',
      avatarUrl: 'https://i.pravatar.cc/150?u=1',
      rating: 4.9,
      availability: ['Mon 10:00 AM', 'Wed 02:00 PM'],
      bio:
          'Board-certified ophthalmologist with 15 years of experience in laser surgery.',
    ),
    const Doctor(
      id: '2',
      name: 'Dr. Michael Chen',
      specialty: 'Retina Specialist',
      avatarUrl: 'https://i.pravatar.cc/150?u=2',
      rating: 4.8,
      availability: ['Tue 09:00 AM', 'Fri 04:00 PM'],
      bio:
          'Expert in diabetic retinopathy and macular degeneration treatments.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tele-Optometry')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassmorphicContainer(
              height: 100,
              width: double.infinity,
              borderRadius: 20,
              blur: 10,
              alignment: Alignment.center,
              border: 1,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.5),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              child: const ListTile(
                leading: Icon(
                  Icons.video_call,
                  color: AppColors.accent,
                  size: 40,
                ),
                title: Text(
                  'Join Instant Consultation',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Talk to a doctor in under 5 minutes',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Eye Specialists',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _mockDoctors[index];
                return Card(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(doctor.avatarUrl),
                    ),
                    title: Text(
                      doctor.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.specialty,
                          style: const TextStyle(color: AppColors.accent),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            Text(
                              ' ${doctor.rating}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      child: const Text(
                        'Book',
                        style: TextStyle(color: Colors.white),
                      ),
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
