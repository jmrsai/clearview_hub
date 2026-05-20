import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialPost {
  final String id;
  final String creatorId;
  final String mediaUrl;
  final String caption;
  final PostType type;
  final int likes;
  final int comments;
  final List<String> tags;

  SocialPost({
    required this.id,
    required this.creatorId,
    required this.mediaUrl,
    required this.caption,
    required this.type,
    this.likes = 0,
    this.comments = 0,
    required this.tags,
  });
}

enum PostType { image, videoReel, exerciseRoutine, therapySession }

/// Instagram/TikTok style infinite feed
class SocialFeedService {
  Future<List<SocialPost>> getFeed({
    required int page,
    required int limit,
  }) async {
    // Mock data for feed
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network

    return [
      SocialPost(
        id: 'post_1',
        creatorId: 'dr_sarah_eyes',
        mediaUrl: 'https://example.com/video1.mp4',
        caption: '5 Minute Eye Yoga Routine for programmers 🧘‍♀️👁️',
        type: PostType.videoReel,
        likes: 1200,
        comments: 45,
        tags: ['#EyeYoga', '#DigitalWellness', '#Focus'],
      ),
      SocialPost(
        id: 'post_2',
        creatorId: 'wellness_guru',
        mediaUrl: 'https://example.com/image1.png',
        caption: 'Remember to take your 20-20-20 break today!',
        type: PostType.image,
        likes: 850,
        comments: 12,
        tags: ['#Reminder', '#CVS'],
      ),
    ];
  }
}

final socialFeedProvider = Provider((ref) => SocialFeedService());
