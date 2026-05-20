import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_article.freezed.dart';
part 'medical_article.g.dart';

@freezed
class MedicalArticle with _$MedicalArticle {
  const factory MedicalArticle({
    required String id,
    required String title,
    required String slug,
    required String content,
    String? summary,
    String? authorId,
    String? sourceOrganization,
    String? sourceUrl,
    required String category,
    @Default([]) List<String> tags,
    @Default(true) bool isVerified,
    String? languageCode,
    @Default(0) int viewCount,
    DateTime? publishedAt,
  }) = _MedicalArticle;

  factory MedicalArticle.fromJson(Map<String, dynamic> json) => _$MedicalArticleFromJson(json);
}
