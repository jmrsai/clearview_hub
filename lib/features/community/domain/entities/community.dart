import 'package:freezed_annotation/freezed_annotation.dart';

part 'community.freezed.dart';
part 'community.g.dart';

@freezed
class Community with _$Community {
  const factory Community({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? iconUrl,
    String? bannerUrl,
    @Default('general') String category,
    @Default(0) int memberCount,
    @Default(false) bool isVerified,
    DateTime? createdAt,
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);
}
