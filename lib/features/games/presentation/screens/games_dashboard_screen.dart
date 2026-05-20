import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/glass_card.dart';

class GamesDashboardScreen extends StatelessWidget {
  const GamesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Games'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F3460), Color(0xFF0A0E1A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Train While You Play',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Engage in activities designed to improve eye health and focus.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      _buildGameCard(
                        context,
                        'Blink Blitz',
                        'Improve lubrication with speed blinking.',
                        Icons.flash_on,
                        Colors.yellowAccent,
                        '/vision_lab/games/blink_blitz',
                      ),
                      _buildGameCard(
                        context,
                        'Focus Pro',
                        'Train your attention and tracking.',
                        Icons.center_focus_strong,
                        Colors.blueAccent,
                        '/vision_lab/games/focus_pro',
                      ),
                      _buildGameCard(
                        context,
                        'Reaction Run',
                        'Test your mental fatigue levels.',
                        Icons.speed,
                        Colors.orangeAccent,
                        null,
                      ),
                      _buildGameCard(
                        context,
                        'Memory Matrix',
                        'Visual memory training exercises.',
                        Icons.extension,
                        Colors.purpleAccent,
                        null,
                      ),
                    ],
                  ),
                ),
                _buildXPBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
    String? route,
  ) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          if (route != null) {
            context.push(route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon in the next update!')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(fontSize: 10, color: Colors.white60),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPBar() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Level 12',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              Text(
                '450 / 600 XP',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
