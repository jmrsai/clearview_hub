import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorProfile {
  final String id;
  final String username;
  final String displayName;
  final String bio;
  final int followers;
  final bool isVerifiedDoctor;
  final CreatorBadge badge;

  CreatorProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.followers,
    this.isVerifiedDoctor = false,
    required this.badge,
  });
}

enum CreatorBadge { newcomer, risingStar, wellnessExpert, verifiedClinic }

/// Manages Creator Profiles, Uploads, and Monetization/Gamification
class CreatorPlatformService {
  CreatorProfile getProfile(String userId) {
    // In production, fetch from Supabase
    return CreatorProfile(
      id: userId,
      username: 'dr_sarah_eyes',
      displayName: 'Dr. Sarah Vision',
      bio: 'Ophthalmologist | Daily Eye Tips & Therapy',
      followers: 12500,
      isVerifiedDoctor: true,
      badge: CreatorBadge.verifiedClinic,
    );
  }

  Future<void> uploadReel({
    required String videoPath,
    required String caption,
    required List<String> wellnessTags,
  }) async {
    // Offline: Cache to Hive 'pending_uploads'
    // Online: Push to Firebase Storage + Supabase DB
  }

  Future<void> uploadStory({
    required String imageOrVideoPath,
    required int durationSeconds,
  }) async {
    // Logic for ephemeral 24h content
  }
}

final creatorPlatformProvider = Provider((ref) => CreatorPlatformService());
