import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class CreatorToolScreen extends StatefulWidget {
  const CreatorToolScreen({super.key});

  @override
  State<CreatorToolScreen> createState() => _CreatorToolScreenState();
}

class _CreatorToolScreenState extends State<CreatorToolScreen> {
  final _contentController = TextEditingController();
  bool _isAiAssisted = false;

  void _publishPost() {
    // Logic to save the post to local feed / cloud
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wellness post published to community!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wellness Post'),
        actions: [
          TextButton(
            onPressed: _publishPost,
            child: const Text(
              'PUBLISH',
              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentController,
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Share your eye health progress or tips...',
                  hintStyle: TextStyle(color: Colors.white30),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildAiAssistantTile(),
            const SizedBox(height: 20),
            _buildMediaUploadTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAssistantTile() {
    return SwitchListTile(
      value: _isAiAssisted,
      onChanged: (v) => setState(() => _isAiAssisted = v),
      title: const Text('AI Content Polish'),
      subtitle: const Text(
        'Let EyeVerse AI improve your post for the community.',
      ),
      secondary: const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
      activeThumbColor: Colors.cyan,
    );
  }

  Widget _buildMediaUploadTile() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.image, color: Colors.cyan),
          const SizedBox(width: 16),
          const Expanded(child: Text('Add Photo or Video')),
          IconButton(icon: const Icon(Icons.add_a_photo), onPressed: () {}),
        ],
      ),
    );
  }
}
