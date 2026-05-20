import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class WellnessTrainingDashboard extends StatelessWidget {
  const WellnessTrainingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellness Training')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Interactive Tests'),
            _buildTrainingGrid([
              _TrainingItem(
                'Eye Strain',
                Icons.visibility,
                Colors.cyan,
                '/wellness_tests',
              ),
              _TrainingItem(
                'Addiction',
                Icons.phonelink_off,
                Colors.orange,
                '/wellness_tests',
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Therapy Sessions'),
            _buildTrainingList([
              _TrainingItem(
                'Eye Muscle Relief',
                Icons.healing,
                Colors.greenAccent,
                '/wellness_therapy',
              ),
              _TrainingItem(
                'Mental Detox',
                Icons.spa,
                Colors.indigoAccent,
                '/wellness_therapy',
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Health Games'),
            _buildTrainingGrid([
              _TrainingItem(
                'Blink Blitz',
                Icons.flash_on,
                Colors.yellowAccent,
                '/vision_lab/games/blink_blitz',
              ),
              _TrainingItem(
                'Focus Pro',
                Icons.center_focus_strong,
                Colors.blueAccent,
                '/vision_lab/games/focus_pro',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTrainingGrid(List<_TrainingItem> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: items.map((item) => _buildCard(item)).toList(),
    );
  }

  Widget _buildTrainingList(List<_TrainingItem> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildWideCard(item),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCard(_TrainingItem item) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: item.color, size: 28),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWideCard(_TrainingItem item) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(item.icon, color: item.color, size: 32),
          const SizedBox(width: 16),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
        ],
      ),
    );
  }
}

class _TrainingItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  _TrainingItem(this.title, this.icon, this.color, this.route);
}
