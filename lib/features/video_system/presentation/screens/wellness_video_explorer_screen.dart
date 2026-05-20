import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/video_ecosystem_service.dart';

class WellnessVideoExplorerScreen extends ConsumerWidget {
  const WellnessVideoExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoService = ref.watch(videoEcosystemProvider);
    final videos = videoService.getRecommendedVideos(
      75.0,
    ); // Simulate high stress

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Cinema'),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryChips(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Top Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return _buildVideoCard(context, video);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', 'Therapy', 'Meditation', 'Focus', 'Education'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(categories[index]),
              selected: index == 0,
              onSelected: (_) {},
              backgroundColor: const Color(0xFF16213E),
              selectedColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: index == 0 ? Colors.white : Colors.white70,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, EducationalVideo video) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFF16213E),
              child: const Icon(
                Icons.video_library,
                size: 50,
                color: Colors.white24,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.black87,
                child: Text(
                  '${(video.durationSeconds / 60).floor()}:${(video.durationSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.spa, color: Colors.white),
          ),
          title: Text(
            video.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'Wellness Expert • 250k views • 2 hours ago',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
          onTap: () {
            // Navigate to Player
          },
        ),
      ],
    );
  }
}
