import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';
import 'package:clearview_hub/features/education/domain/entities/educational_content.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Prevention',
    'Nutrition',
    'Children',
    'Workspace',
  ];

  final List<EducationalContent> _content = [
    const EducationalContent(
      id: '1',
      title: 'Protecting your eyes in the digital age',
      description: 'Learn the 20-20-20 rule and other ergonomic tips.',
      category: 'Workspace',
      type: ContentType.article,
      imageUrl:
          'https://images.unsplash.com/photo-1591076482161-42ce6da69f67?q=80&w=300&h=200&auto=format&fit=crop',
    ),
    const EducationalContent(
      id: '2',
      title: 'Top 5 foods for better vision',
      description: 'Superfoods that can help prevent macular degeneration.',
      category: 'Nutrition',
      type: ContentType.video,
      duration: '5:24',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=300&h=200&auto=format&fit=crop',
    ),
    const EducationalContent(
      id: '3',
      title: 'Common eye conditions in children',
      description: 'How to spot early signs of myopia and amblyopia.',
      category: 'Children',
      type: ContentType.lesson,
      imageUrl:
          'https://images.unsplash.com/photo-1543332145-6e82f7f80582?q=80&w=300&h=200&auto=format&fit=crop',
    ),
    const EducationalContent(
      id: '4',
      title: 'Eye Exercises Infographic',
      description: 'A quick guide to daily eye muscle stretches.',
      category: 'Prevention',
      type: ContentType.infographic,
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?q=80&w=300&h=200&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Hub'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search articles, videos, lessons...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategory == _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (val) =>
                        setState(() => _selectedCategory = _categories[index]),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    selectedColor: AppColors.accent.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.accent : Colors.white70,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _content.length,
              itemBuilder: (context, index) {
                final item = _content[index];
                if (_selectedCategory != 'All' &&
                    item.category != _selectedCategory) {
                  return const SizedBox.shrink();
                }
                return _buildContentCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(EducationalContent item) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (item.type == ContentType.video)
                Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.type.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
