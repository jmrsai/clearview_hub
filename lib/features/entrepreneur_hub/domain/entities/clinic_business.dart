import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic_business.freezed.dart';
part 'clinic_business.g.dart';

@freezed
class ClinicBusiness with _$ClinicBusiness {
  const factory ClinicBusiness({
    required String id,
    required String ownerId,
    required String businessName,
    required String businessType, // 'clinic', 'startup', 'optical_store'
    String? description,
    String? contactEmail,
    String? contactPhone,
    String? websiteUrl,
    Map<String, dynamic>? address,
    @Default('pending') String verificationStatus,
    @Default('free') String subscriptionTier,
    DateTime? createdAt,
  }) = _ClinicBusiness;

  factory ClinicBusiness.fromJson(Map<String, dynamic> json) => _$ClinicBusinessFromJson(json);
}
