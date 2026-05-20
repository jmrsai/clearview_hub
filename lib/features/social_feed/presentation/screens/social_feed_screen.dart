import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../widgets/glass_card.dart';
import '../../domain/models/wellness_post.dart';

import '../widgets/wellness_video_player.dart';

class SocialWellnessFeedScreen extends StatefulWidget {
  const SocialWellnessFeedScreen({super.key});

  @override
  State<SocialWellnessFeedScreen> createState() =>
      _SocialWellnessFeedScreenState();
}

class _SocialWellnessFeedScreenState extends State<SocialWellnessFeedScreen> {
  static const _pageSize = 10;
  final PagingController<int, WellnessPost> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Simulate API fetch delay
      await Future.delayed(const Duration(seconds: 1));

      final List<WellnessPost> newItems = List.generate(
        _pageSize,
        (index) => WellnessPost(
          id: '${pageKey}_$index',
          authorId: 'user_$index',
          authorName: 'Wellness Expert $index',
          authorAvatar:
              'https://api.dicebear.com/7.x/avataaars/svg?seed=$index',
          content:
              'Keep your eyes healthy by following the 20-20-20 rule! This is post ${pageKey * _pageSize + index}.',
          timestamp: DateTime.now().subtract(Duration(hours: index)),
          likesCount: index * 10,
          commentsCount: index * 2,
          isAiGenerated: index % 3 == 0,
        ),
      );

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E1A), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildStoriesSection(),
              Expanded(
                child: PagedListView<int, WellnessPost>(
                  pagingController: _pagingController,
                  padding: const EdgeInsets.all(16),
                  builderDelegate: PagedChildBuilderDelegate<WellnessPost>(
                    itemBuilder: (context, item, index) => _buildPostCard(item),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'EyeVerse Social',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.video_collection, color: Colors.cyan),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.cyan),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Colors.blueAccent],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://api.dicebear.com/7.x/avataaars/svg?seed=story_$index',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'User $index',
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(WellnessPost post) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(post.authorAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    post.isAiGenerated ? 'AI Wellness Coach' : 'Wellness Guru',
                    style: TextStyle(fontSize: 11, color: Colors.cyan.shade300),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            post.content,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          if (post.isAiGenerated) ...[
            const SizedBox(height: 16),
            const WellnessVideoPlayer(
              videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.favorite_border,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${post.likesCount}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${post.commentsCount}',
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              const Icon(
                Icons.bookmark_border,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
