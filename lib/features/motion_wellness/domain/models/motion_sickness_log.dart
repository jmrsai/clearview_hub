import 'package:freezed_annotation/freezed_annotation.dart';

part 'motion_sickness_log.freezed.dart';
part 'motion_sickness_log.g.dart';

@freezed
class MotionSicknessLog with _$MotionSicknessLog {
  const factory MotionSicknessLog({
    required String id,
    required DateTime timestamp,
    @Default(0.0) double nauseaLevel,
    @Default(0.0) double dizzinessLevel,
    @Default(0.0) double eyeStrainLevel,
    @Default(0.0) double headacheLevel,
    @Default(false) bool vomitingTendency,
    @Default([]) List<String> triggers,
    String? notes,
  }) = _MotionSicknessLog;

  factory MotionSicknessLog.fromJson(Map<String, dynamic> json) =>
      _$MotionSicknessLogFromJson(json);
}
