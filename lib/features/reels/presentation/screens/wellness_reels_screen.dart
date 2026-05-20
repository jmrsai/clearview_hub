import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/reels_stories_service.dart';

class WellnessReelsScreen extends ConsumerWidget {
  const WellnessReelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reelsService = ref.watch(reelsAndStoriesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Reel>>(
        future: reelsService.getExploreReels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final reels = snapshot.data ?? [];

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return _buildReelItem(context, reels[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildReelItem(BuildContext context, Reel reel) {
    return Stack(
      children: [
        // Background Video Placeholder
        Container(
          color: Colors.black,
          child: const Center(
            child: Icon(Icons.play_arrow, size: 100, color: Colors.white24),
          ),
        ),

        // Right Side Actions
        Positioned(
          right: 15,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(Icons.favorite, reel.likes.toString()),
              const SizedBox(height: 20),
              _buildActionButton(Icons.comment, '45'),
              const SizedBox(height: 20),
              _buildActionButton(Icons.share, reel.shares.toString()),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ),

        // Bottom Content
        Positioned(
          left: 15,
          right: 80,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${reel.creatorId}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                reel.caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 15),
                  SizedBox(width: 5),
                  Text(
                    'Wellness Beats - Original Sound',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Top Navigation
        Positioned(
          top: 50,
          left: 15,
          right: 15,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Text(
                'Reels',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 35),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
