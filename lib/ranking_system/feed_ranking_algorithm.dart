import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPost {
  final String id;
  final String content;
  final double relevanceScore;
  final double wellnessValue;
  final int likes;
  final int comments;
  final DateTime timestamp;

  FeedPost({
    required this.id,
    required this.content,
    this.relevanceScore = 1.0,
    this.wellnessValue = 1.0,
    this.likes = 0,
    this.comments = 0,
    required this.timestamp,
  });
}

/// Social Feed Ranking Algorithm
class FeedRankingAlgorithm {
  List<FeedPost> rankFeed(
    List<FeedPost> rawFeed, {
    required List<String> userInterests,
  }) {
    List<Map<String, dynamic>> scoredPosts = [];

    final now = DateTime.now();

    for (var post in rawFeed) {
      double score = 0;

      // 1. Recency decay (newer is better, but decays exponentially)
      final hoursOld = now.difference(post.timestamp).inHours;
      double recencyMultiplier = 1.0 / ((hoursOld + 1) * 0.5);

      // 2. Wellness value (boosts therapy/health content over memes)
      double wellnessBoost = post.wellnessValue * 2.5;

      // 3. Engagement quality
      double engagementScore = (post.likes * 1.0) + (post.comments * 2.0);

      // Final calculation
      score =
          (post.relevanceScore * 10) +
          wellnessBoost +
          (engagementScore * 0.5) * recencyMultiplier;

      scoredPosts.add({'post': post, 'finalScore': score});
    }

    // Sort descending by finalScore
    scoredPosts.sort(
      (a, b) =>
          (b['finalScore'] as double).compareTo(a['finalScore'] as double),
    );

    return scoredPosts.map((e) => e['post'] as FeedPost).toList();
  }
}

final feedRankingProvider = Provider((ref) => FeedRankingAlgorithm());
