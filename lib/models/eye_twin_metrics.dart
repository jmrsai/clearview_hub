import 'package:hive/hive.dart';

part 'eye_twin_metrics.g.dart';

@HiveType(typeId: 1)
class EyeTwinMetrics {
  @HiveField(0)
  final String patientId;

  @HiveField(1)
  final double visualAcuityScore; // 0-100

  @HiveField(2)
  final double screenTimeHours;

  @HiveField(3)
  final double fatigueLevel; // 0.0 - 1.0

  @HiveField(4)
  final double therapyAdherence; // 0.0 - 1.0

  @HiveField(5)
  final DateTime lastUpdated;

  EyeTwinMetrics({
    required this.patientId,
    required this.visualAcuityScore,
    required this.screenTimeHours,
    required this.fatigueLevel,
    required this.therapyAdherence,
    required this.lastUpdated,
  });
}
