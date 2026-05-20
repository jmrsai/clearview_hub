import 'package:freezed_annotation/freezed_annotation.dart';

part 'wellness_post.freezed.dart';
part 'wellness_post.g.dart';

@freezed
class WellnessPost with _$WellnessPost {
  const factory WellnessPost({
    required String id,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String content,
    String? mediaUrl,
    @Default(false) bool isAiGenerated,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    required DateTime timestamp,
    @Default([]) List<String> tags,
  }) = _WellnessPost;

  factory WellnessPost.fromJson(Map<String, dynamic> json) =>
      _$WellnessPostFromJson(json);
}
