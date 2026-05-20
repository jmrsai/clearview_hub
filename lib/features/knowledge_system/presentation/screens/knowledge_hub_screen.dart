import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class KnowledgeHubScreen extends ConsumerWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Eye Health Knowledge'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Verified by Medical Experts', icon: Icons.verified_user),
            const SizedBox(height: 16),
            _buildCategoryGrid(),
            const SizedBox(height: 32),
            const _SectionHeader(title: 'Trending Articles', icon: Icons.trending_up),
            const SizedBox(height: 16),
            _buildArticleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search diseases, symptoms, treatments...',
        prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
        suffixIcon: const Icon(Icons.mic, color: AppColors.textSecondary),
        fillColor: AppColors.surfaceElevated,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'title': 'Diseases', 'icon': Icons.coronavirus, 'color': Colors.redAccent},
      {'title': 'Symptoms', 'icon': Icons.visibility_off, 'color': Colors.orangeAccent},
      {'title': 'Treatments', 'icon': Icons.medical_services, 'color': Colors.green},
      {'title': 'Anatomy 3D', 'icon': Icons.threed_rotation, 'color': Colors.purpleAccent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(cat['icon'] as IconData, color: cat['color'] as Color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cat['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Glaucoma', style: TextStyle(color: AppColors.secondary, fontSize: 12)),
                  ),
                  const Spacer(),
                  const Icon(Icons.verified, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  const Text('WHO Verified', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Understanding Glaucoma: Early Signs and Prevention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Glaucoma is a group of eye conditions that damage the optic nerve, the health of which is vital for good vision...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
