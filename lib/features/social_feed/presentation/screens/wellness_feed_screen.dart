import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/social_feed_service.dart';

class WellnessFeedScreen extends ConsumerWidget {
  const WellnessFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedService = ref.watch(socialFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wellness Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.send_outlined), onPressed: () {}),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<SocialPost>>(
        future: feedService.getFeed(page: 1, limit: 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostCard(context, post);
            },
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, SocialPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            post.creatorId,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: const Text(
            'Verified Clinic',
            style: TextStyle(color: Colors.blueAccent, fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ),
        Container(
          height: 300,
          width: double.infinity,
          color: const Color(0xFF16213E),
          child: post.type == PostType.videoReel
              ? const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: Colors.white54,
                  ),
                )
              : const Center(
                  child: Icon(Icons.image, size: 60, color: Colors.white54),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.favorite_border, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.chat_bubble_outline, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.send_outlined, color: Colors.white),
                  Spacer(),
                  Icon(Icons.bookmark_border, color: Colors.white),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${post.likes} likes',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${post.creatorId} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.tags.join(' '),
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
