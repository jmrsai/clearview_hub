import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';
import 'package:clearview_hub/features/community/domain/entities/community_post.dart';
import 'package:clearview_hub/features/community/domain/entities/community.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  final List<CommunityPost> _mockPosts = [
    CommunityPost(
      id: '1',
      communityId: '1',
      authorName: 'Sarah Jenkins',
      authorAvatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah',
      content:
          'Just finished my first week of lazy eye therapy! Seeing some progress already. #EyeHealth #Progress',
      title: 'Therapy Progress',
      upvotes: 24,
      comment_count: 5,
    ),
  ];

  final List<Community> _mockGroups = const [
    Community(
      id: '1',
      name: 'Glaucoma Support',
      description:
          'A space to share experiences and tips for living with glaucoma.',
      memberCount: 1250,
      slug: 'glaucoma-support',
      category: 'Chronic Conditions',
      bannerUrl:
          'https://images.unsplash.com/photo-1576091160607-212d12db7241?q=80&w=300&h=200&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EyeVerse Community'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Groups'),
            ],
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.secondary,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.feed_outlined),
              onPressed: () => context.push('/community/feed'),
            ),
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
        body: TabBarView(children: [_buildFeedTab(context), _buildGroupsTab()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/community/create'),
          backgroundColor: AppColors.secondary,
          child: const Icon(Icons.add_photo_alternate_outlined),
        ),
      ),
    );
  }

  Widget _buildFeedTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockPosts.length,
      itemBuilder: (context, index) {
        final post = _mockPosts[index];
        return Card(
          color: Colors.white.withOpacity(0.05),
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: post.authorAvatarUrl != null ? NetworkImage(post.authorAvatarUrl!) : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName ?? 'Anonymous',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '2 hours ago',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white54),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.content,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.upvotes}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white54,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comment_count}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockGroups.length,
      itemBuilder: (context, index) {
        final group = _mockGroups[index];
        return Card(
          color: Colors.white.withOpacity(0.05),
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: group.bannerUrl != null ? Image.network(
                  group.bannerUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ) : Container(width: 100, height: 100, color: Colors.grey),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${group.memberCount} members',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text(
                          'Join Group',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
