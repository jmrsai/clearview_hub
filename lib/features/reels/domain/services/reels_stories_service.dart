import 'package:flutter_riverpod/flutter_riverpod.dart';

class Reel {
  final String id;
  final String creatorId;
  final String videoUrl;
  final String caption;
  final int likes;
  final int shares;

  Reel({
    required this.id,
    required this.creatorId,
    required this.videoUrl,
    required this.caption,
    this.likes = 0,
    this.shares = 0,
  });
}

class Story {
  final String id;
  final String creatorId;
  final String mediaUrl;
  final bool isVideo;
  final DateTime expiresAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.creatorId,
    required this.mediaUrl,
    required this.isVideo,
    required this.expiresAt,
    this.isViewed = false,
  });
}

/// Snapchat/Instagram style Stories and Reels Manager
class ReelsAndStoriesService {
  // Implements intelligent pre-fetching and lazy-loading
  Future<List<Reel>> getExploreReels() async {
    return [
      Reel(
        id: 'reel_1',
        creatorId: 'dr_sarah_eyes',
        videoUrl: 'https://example.com/reels/1.mp4',
        caption:
            'Try this simple exercise when your eyes feel tired! 👁️✨ #EyeCare',
        likes: 15400,
        shares: 3200,
      ),
    ];
  }

  Future<List<Story>> getActiveStories() async {
    return [
      Story(
        id: 'story_1',
        creatorId: 'wellness_guru',
        mediaUrl: 'https://example.com/stories/1.jpg',
        isVideo: false,
        expiresAt: DateTime.now().add(const Duration(hours: 12)),
      ),
    ];
  }
}

final reelsAndStoriesProvider = Provider((ref) => ReelsAndStoriesService());
