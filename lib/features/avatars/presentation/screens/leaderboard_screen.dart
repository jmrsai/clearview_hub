import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wellness Leaderboard')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E1A), Color(0xFF16213E)],
          ),
        ),
        child: Column(
          children: [
            _buildTopThree(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index < 3) return const SizedBox.shrink();
                  return _buildLeaderboardTile(index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumItem('User B', '2.4k XP', 2, Colors.grey.shade400, 60),
          _buildPodiumItem('User A', '3.1k XP', 1, Colors.yellowAccent, 80),
          _buildPodiumItem(
            'User C',
            '2.1k XP',
            3,
            Colors.orangeAccent.shade100,
            50,
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    String name,
    String xp,
    int rank,
    Color color,
    double size,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: CircleAvatar(
                radius: size / 2,
                backgroundImage: NetworkImage(
                  'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(xp, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaderboardTile(int rank) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: const TextStyle(
              color: Colors.white38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://api.dicebear.com/7.x/avataaars/svg?seed=user$rank',
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Wellness User',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            '1.8k XP',
            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
