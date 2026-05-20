import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class WellnessReelsFeedScreen extends StatefulWidget {
  const WellnessReelsFeedScreen({super.key});

  @override
  State<WellnessReelsFeedScreen> createState() => _WellnessReelsFeedScreenState();
}

class _WellnessReelsFeedScreenState extends State<WellnessReelsFeedScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _reelsData = [
    {
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'user': '@DrSarahEyeCare',
      'description': 'How to properly do a warm compress for styes! 🔥 #EyeHealth',
      'likes': '12.4k',
      'comments': '342',
    },
    {
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'user': '@VisionPlusClinic',
      'description': 'Are blue light glasses actually worth it? Watch this! 👓 #BlueLight',
      'likes': '8.9k',
      'comments': '120',
    },
    {
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'user': '@OptometryDaily',
      'description': '3 signs you might have astigmatism. 👀 #Astigmatism',
      'likes': '45.1k',
      'comments': '890',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Wellness Reels', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reelsData.length,
        itemBuilder: (context, index) {
          return ReelVideoPlayer(reelData: _reelsData[index]);
        },
      ),
    );
  }
}

class ReelVideoPlayer extends StatefulWidget {
  final Map<String, dynamic> reelData;

  const ReelVideoPlayer({super.key, required this.reelData});

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reelData['videoUrl']))
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ),
        
        // Play/Pause Overlay Icon
        if (!_isPlaying)
          Center(
            child: Icon(Icons.play_arrow, size: 80, color: Colors.white.withValues(alpha: 0.5)),
          ),

        // Gradient overlay for text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Text Content
        Positioned(
          bottom: 32,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reelData['user'],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                widget.reelData['description'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),

        // Right side interaction buttons
        Positioned(
          bottom: 32,
          right: 16,
          child: Column(
            children: [
              _buildInteractionButton(Icons.favorite, widget.reelData['likes'], color: Colors.red),
              const SizedBox(height: 24),
              _buildInteractionButton(Icons.comment, widget.reelData['comments']),
              const SizedBox(height: 24),
              _buildInteractionButton(Icons.share, 'Share'),
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionButton(IconData icon, String label, {Color color = Colors.white}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
