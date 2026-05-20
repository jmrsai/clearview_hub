import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class MotionWellnessScreen extends StatefulWidget {
  const MotionWellnessScreen({super.key});

  @override
  State<MotionWellnessScreen> createState() => _MotionWellnessScreenState();
}

class _MotionWellnessScreenState extends State<MotionWellnessScreen> {
  double _nausea = 0.0;
  double _dizziness = 0.0;
  bool _travelMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel & Motion Wellness')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTravelModeToggle(),
            const SizedBox(height: 24),
            const Text(
              'Log Symptoms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSymptomSlider(
              'Nausea',
              _nausea,
              (v) => setState(() => _nausea = v),
            ),
            _buildSymptomSlider(
              'Dizziness',
              _dizziness,
              (v) => setState(() => _dizziness = v),
            ),
            const SizedBox(height: 24),
            _buildRiskIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Anti-Nausea Exercises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExerciseCard(
              'Horizon Focus',
              'Fix your gaze on the distant horizon to stabilize your balance.',
            ),
            _buildExerciseCard(
              'Slow Blinking',
              'Blink slowly and deliberately to refocus your vision.',
            ),
            _buildExerciseCard(
              'Deep Breathing',
              'Rhythmic breathing to calm the nervous system.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelModeToggle() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: Colors.cyan, size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel Mode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Optimize UI for vehicle usage',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Switch(
            value: _travelMode,
            onChanged: (v) => setState(() => _travelMode = v),
            activeThumbColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.cyan,
          inactiveColor: Colors.white10,
        ),
      ],
    );
  }

  Widget _buildRiskIndicator() {
    final double risk = (_nausea + _dizziness) / 2;
    Color statusColor = Colors.green;
    if (risk > 0.7) {
      statusColor = Colors.red;
    } else if (risk > 0.3)
      statusColor = Colors.orange;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Wellness Risk Score'),
          const SizedBox(height: 12),
          Text(
            '${(risk * 100).toInt()}%',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          Text(
            risk > 0.5
                ? 'High Risk: Take a break'
                : 'Low Risk: You are doing well',
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
