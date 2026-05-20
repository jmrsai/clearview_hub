import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/community_provider.dart';
import '../../domain/entities/community_post.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class CommunityFeedScreen extends ConsumerWidget {
  final String communityId;
  final String communityName;

  const CommunityFeedScreen({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(communityPostsProvider(communityId));

    return Scaffold(
      appBar: AppBar(
        title: Text(communityName),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {}, // Community Info
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.read(communityPostsProvider(communityId).notifier).fetchPosts(refresh: true),
          child: posts.isEmpty 
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _CommunityPostCard(post: posts[index]);
                },
              ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostModal(context, ref),
        label: const Text('Post'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 80, color: AppColors.textDisabled),
          SizedBox(height: 16),
          Text('No discussions yet. Be the first to post!', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context, WidgetRef ref) {
    // Implementation for creating a post (omitted for brevity in this step)
  }
}

class _CommunityPostCard extends ConsumerWidget {
  final CommunityPost post;

  const _CommunityPostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: post.authorAvatarUrl != null ? NetworkImage(post.authorAvatarUrl!) : null,
                child: post.authorAvatarUrl == null ? const Icon(Icons.person, size: 16) : null,
              ),
              const SizedBox(width: 8),
              Text(
                post.authorName ?? 'Anonymous',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '2h ago', // TODO: Format post.createdAt
                style: const TextStyle(fontSize: 10, color: AppColors.textDisabled),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ReactionButton(
                icon: Icons.arrow_upward_rounded,
                label: '${post.upvotes}',
                isActive: post.isUpvotedByMe,
                color: Colors.orange,
                onTap: () => ref.read(communityPostsProvider(post.communityId).notifier).toggleUpvote(post.id),
              ),
              const SizedBox(width: 16),
              _ReactionButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post.comment_count}',
                isActive: false,
                color: Colors.blue,
                onTap: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20, color: AppColors.textSecondary),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? color : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? color : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color: isActive ? color : AppColors.textSecondary
              ),
            ),
          ],
        ),
      ),
    );
  }
}
