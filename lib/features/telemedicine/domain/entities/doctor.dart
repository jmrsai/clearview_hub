import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
class Doctor with _$Doctor {
  const factory Doctor({
    required String id,
    required String name,
    required String specialization,
    String? hospitalAffiliation,
    String? avatarUrl,
    String? bio,
    @Default(5.0) double rating,
    @Default(0.0) double consultationFee,
    @Default(true) bool isAvailable,
    @Default([]) List<Map<String, dynamic>> availableHours,
  }) = _Doctor;

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
}
