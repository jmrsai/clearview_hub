import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/creator_service.dart';

class CreatorDashboardScreen extends ConsumerWidget {
  const CreatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creatorService = ref.watch(creatorPlatformProvider);
    final profile = creatorService.getProfile('current_user');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Studio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            const Text(
              'Your Recent Wellness Content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildContentList(),
            const SizedBox(height: 24),
            _buildUploadButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(CreatorProfile profile) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    profile.displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (profile.isVerifiedDoctor)
                    const Icon(
                      Icons.verified,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                ],
              ),
              Text(
                '@${profile.username}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 8),
              Text(
                profile.bio,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('12.5k', 'Followers', Icons.people, Colors.blueAccent),
        _buildStatCard(
          '450k',
          'Impact Score',
          Icons.favorite,
          Colors.pinkAccent,
        ),
        _buildStatCard(
          '85',
          'Wellness Reels',
          Icons.play_circle_fill,
          Colors.orangeAccent,
        ),
        _buildStatCard('12', 'Shared Therapies', Icons.spa, Colors.greenAccent),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFF16213E),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: Colors.white10,
              child: const Icon(Icons.image, color: Colors.white24),
            ),
            title: Text(
              'Wellness Video #$index',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${index * 1200} views • ${index + 1} days ago',
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: const Icon(
              Icons.analytics_outlined,
              color: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
            label: const Text('New Reel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history),
            label: const Text('Manage'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blueAccent),
              foregroundColor: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
  }
}
