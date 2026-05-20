import 'package:flutter/material.dart';
import '../../domain/models/wellness_story.dart';
import '../../../../widgets/glass_card.dart';

class WellnessStoriesScreen extends StatefulWidget {
  final List<WellnessStory> stories;
  final int initialIndex;

  const WellnessStoriesScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<WellnessStoriesScreen> createState() => _WellnessStoriesScreenState();
}

class _WellnessStoriesScreenState extends State<WellnessStoriesScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.stories.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final story = widget.stories[index];
              return _buildStoryItem(story);
            },
          ),

          // Story Progress Bars
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: List.generate(
                widget.stories.length,
                (index) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentIndex
                          ? Colors.cyan
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(WellnessStory story) {
    return Stack(
      children: [
        // Media
        Center(
          child: Image.network(
            story.mediaUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ),

        // Header info
        Positioned(
          top: 70,
          left: 20,
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(story.authorAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.authorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '4h ago',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Caption
        if (story.caption != null)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Text(
              story.caption!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
