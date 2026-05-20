import 'package:freezed_annotation/freezed_annotation.dart';

part 'wellness_story.freezed.dart';
part 'wellness_story.g.dart';

@freezed
class WellnessStory with _$WellnessStory {
  const factory WellnessStory({
    required String id,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String mediaUrl,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default(false) bool isViewed,
    String? caption,
  }) = _WellnessStory;

  factory WellnessStory.fromJson(Map<String, dynamic> json) =>
      _$WellnessStoryFromJson(json);
}
