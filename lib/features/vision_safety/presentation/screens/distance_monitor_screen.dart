import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/glass_card.dart';

class DistanceMonitorScreen extends ConsumerWidget {
  const DistanceMonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vision Safety Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phonelink_setup, size: 80, color: Colors.cyan),
            const SizedBox(height: 24),
            const Text(
              'Screen Distance Monitoring',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We use front-camera AI to detect if your phone is too close to your eyes, preventing digital eye strain.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 40),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Monitoring Status: ACTIVE',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Toggle monitoring
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.2),
                    ),
                    child: const Text(
                      'STOP MONITORING',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
