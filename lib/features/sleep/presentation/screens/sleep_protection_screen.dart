import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class SleepProtectionScreen extends StatelessWidget {
  const SleepProtectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Protection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildNightModeCard(),
            const SizedBox(height: 24),
            _buildSleepMetric(
              'Bedtime Usage',
              '1h 45m',
              Icons.nightlight_round,
              Colors.indigoAccent,
            ),
            _buildSleepMetric(
              'Blue Light Exposure',
              'High',
              Icons.wb_iridescent,
              Colors.blueAccent,
            ),
            _buildSleepMetric(
              'Phone Pickups',
              '12 times',
              Icons.phonelink_ring,
              Colors.tealAccent,
            ),
            const SizedBox(height: 24),
            _buildLockSuggestion(),
          ],
        ),
      ),
    );
  }

  Widget _buildNightModeCard() {
    return const GlassCard(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.bedtime, color: Colors.indigoAccent, size: 64),
          SizedBox(height: 16),
          Text(
            'Sleep Protection: ACTIVE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigoAccent,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We are reducing blue light and dimming animations to prepare your brain for sleep.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLockSuggestion() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Text(
            'Improve Your Sleep',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          const Text(
            'You typically use your phone for 45 mins after bedtime. Would you like to enable a bedtime lock?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
            child: const Text('ENABLE BEDTIME LOCK'),
          ),
        ],
      ),
    );
  }
}
