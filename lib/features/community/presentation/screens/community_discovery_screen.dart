import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/community_provider.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class CommunityDiscoveryScreen extends ConsumerWidget {
  const CommunityDiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(communitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EyeVerse Communities'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildCategoryTabs(),
        ),
      ),
      body: communitiesAsync.when(
        data: (communities) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final community = communities[index];
            return InkWell(
              onTap: () => context.pushNamed(
                'community_feed',
                pathParameters: {'id': community.id},
                extra: community.name,
              ),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      backgroundImage: community.iconUrl != null ? NetworkImage(community.iconUrl!) : null,
                      child: community.iconUrl == null ? const Icon(Icons.group, size: 30, color: AppColors.secondary) : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      community.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${community.memberCount} members',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    if (community.isVerified)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.blue),
                          SizedBox(width: 4),
                          Text('Medical Pro', style: TextStyle(fontSize: 10, color: Colors.blue)),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _CategoryChip(label: 'All', isActive: true, onTap: () {}),
          _CategoryChip(label: 'Clinical Support', isActive: false, onTap: () {}),
          _CategoryChip(label: 'Lifestyle', isActive: false, onTap: () {}),
          _CategoryChip(label: 'Research', isActive: false, onTap: () {}),
          _CategoryChip(label: 'Workplace', isActive: false, onTap: () {}),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.secondary,
        backgroundColor: AppColors.surfaceElevated,
        labelStyle: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary),
      ),
    );
  }
}
