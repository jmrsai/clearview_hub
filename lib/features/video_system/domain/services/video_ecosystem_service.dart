import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducationalVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationSeconds;
  final VideoCategory category;
  final bool isDownloaded;

  EducationalVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.durationSeconds,
    required this.category,
    this.isDownloaded = false,
  });
}

enum VideoCategory {
  eyeTherapy,
  guidedMeditation,
  focusMusic,
  wellnessEducation,
}

/// YouTube-style Educational Video and Playlist System
class VideoEcosystemService {
  List<EducationalVideo> getRecommendedVideos(double currentStressLevel) {
    List<EducationalVideo> recommendations = [];

    if (currentStressLevel > 60) {
      recommendations.add(
        EducationalVideo(
          id: 'v_1',
          title: '10 Minute Guided Meditation for Eye Relief',
          thumbnailUrl: 'assets/images/meditation_thumb.jpg',
          videoUrl: 'https://example.com/meditation.mp4',
          durationSeconds: 600,
          category: VideoCategory.guidedMeditation,
        ),
      );
    }

    recommendations.add(
      EducationalVideo(
        id: 'v_2',
        title: 'Understanding Digital Eye Strain',
        thumbnailUrl: 'assets/images/edu_thumb.jpg',
        videoUrl: 'https://example.com/education.mp4',
        durationSeconds: 300,
        category: VideoCategory.wellnessEducation,
      ),
    );

    return recommendations;
  }

  Future<void> downloadVideoForOffline(String videoId) async {
    // Implement video caching using flutter_cache_manager
  }
}

final videoEcosystemProvider = Provider((ref) => VideoEcosystemService());
