import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../widgets/glass_card.dart';

class DigitalWellbeingScreen extends StatelessWidget {
  const DigitalWellbeingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Wellbeing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAddictionScoreCard(),
            const SizedBox(height: 24),
            _buildAppUsageSection(),
            const SizedBox(height: 24),
            _buildFocusModeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddictionScoreCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Screen Addiction Score',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: 0.65,
            center: const Text(
              '65%',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            progressColor: Colors.orangeAccent,
            backgroundColor: Colors.white10,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          const SizedBox(height: 20),
          const Text(
            'Status: Moderate Dependency',
            style: TextStyle(color: Colors.orangeAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Distractions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildUsageItem('Social Media', 0.8, '3h 15m', Colors.blue),
          _buildUsageItem('Gaming', 0.4, '1h 20m', Colors.red),
          _buildUsageItem('Streaming', 0.6, '2h 10m', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildUsageItem(
    String label,
    double percent,
    String time,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percent,
            progressColor: color,
            backgroundColor: Colors.white10,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildFocusModeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.center_focus_strong, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deep Work Focus',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Block all distractions for 45 mins',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
            ),
            child: const Text('START'),
          ),
        ],
      ),
    );
  }
}
