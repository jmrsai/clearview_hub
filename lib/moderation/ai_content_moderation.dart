import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModerationResult {
  final bool isSafe;
  final double toxicityScore;
  final String reason;

  ModerationResult({
    required this.isSafe,
    required this.toxicityScore,
    required this.reason,
  });
}

/// AI Content Moderation System (Local Rule-Based)
class AIContentModeration {
  // Basic list for local rapid checking before cloud API fallback
  final List<String> _toxicityKeywords = [
    'hate', 'ugly', 'stupid', 'die', 'kill', // Simplified for prototype
  ];

  final List<String> _spamKeywords = [
    'buy now',
    'crypto',
    'subscribe to my',
    'free money',
  ];

  ModerationResult checkContentLocal(String text) {
    final lowerText = text.toLowerCase();

    double toxicityScore = 0.0;

    for (var word in _toxicityKeywords) {
      if (lowerText.contains(word)) {
        toxicityScore += 30.0;
      }
    }

    if (toxicityScore > 50) {
      return ModerationResult(
        isSafe: false,
        toxicityScore: toxicityScore,
        reason: 'High toxicity detected.',
      );
    }

    int spamMatches = 0;
    for (var word in _spamKeywords) {
      if (lowerText.contains(word)) {
        spamMatches++;
      }
    }

    if (spamMatches >= 2) {
      return ModerationResult(
        isSafe: false,
        toxicityScore: toxicityScore,
        reason: 'Spam behavior detected.',
      );
    }

    return ModerationResult(
      isSafe: true,
      toxicityScore: toxicityScore,
      reason: 'Content is safe.',
    );
  }
}

final moderationProvider = Provider((ref) => AIContentModeration());
