import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_post.freezed.dart';
part 'community_post.g.dart';

@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String communityId,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    required String title,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default(false) bool isAnonymous,
    @Default(0) int upvotes,
    @Default(0) int downvotes,
    @Default(0) int comment_count,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    // UI Local State
    @Default(false) bool isUpvotedByMe,
    @Default(false) bool isDownvotedByMe,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) => _$CommunityPostFromJson(json);
}
