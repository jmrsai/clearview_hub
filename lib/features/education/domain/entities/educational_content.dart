enum ContentType { video, article, quiz, infographic, lesson }

class EducationalContent {
  final String id;
  final String title;
  final String description;
  final String category;
  final ContentType type;
  final String imageUrl;
  final String? duration;
  final String? videoUrl;

  const EducationalContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.imageUrl,
    this.duration,
    this.videoUrl,
  });
}
