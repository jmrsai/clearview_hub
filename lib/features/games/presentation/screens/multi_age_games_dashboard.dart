import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class MultiAgeGamesDashboard extends StatelessWidget {
  const MultiAgeGamesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eye Training Games')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAgeSection('Children (5-12)', Colors.pinkAccent, [
              _GameItem(
                'Blink Hero',
                Icons.flash_on,
                'Fun cartoons + quick blinking.',
              ),
              _GameItem(
                'Color Catch',
                Icons.color_lens,
                'Identify colors to relax eyes.',
              ),
            ]),
            const SizedBox(height: 24),
            _buildAgeSection('Teens (13-19)', Colors.blueAccent, [
              _GameItem(
                'Focus Tracker',
                Icons.track_changes,
                'Fast tracking with high-res UI.',
              ),
              _GameItem(
                'Reaction Grid',
                Icons.grid_view,
                'Improve ocular reaction time.',
              ),
            ]),
            const SizedBox(height: 24),
            _buildAgeSection('Adults (20-50)', Colors.cyanAccent, [
              _GameItem(
                '20-20-20 Challenge',
                Icons.timer,
                'Productivity-based eye recovery.',
              ),
              _GameItem(
                'Focus Lock',
                Icons.lock_outline,
                'Maintain gaze on moving targets.',
              ),
            ]),
            const SizedBox(height: 24),
            _buildAgeSection('Seniors (50+)', Colors.orangeAccent, [
              _GameItem(
                'Gentle Movement',
                Icons.sync,
                'Slow ocular rotation training.',
              ),
              _GameItem(
                'Memory Picture',
                Icons.image_search,
                'Relaxing visual memory drills.',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSection(String title, Color color, List<_GameItem> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(game.icon, color: color, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        game.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        game.desc,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GameItem {
  final String name;
  final IconData icon;
  final String desc;
  _GameItem(this.name, this.icon, this.desc);
}
