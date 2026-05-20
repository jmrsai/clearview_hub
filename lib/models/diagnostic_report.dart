import 'package:hive/hive.dart';

part 'diagnostic_report.g.dart';

@HiveType(typeId: 2)
class DiagnosticReport {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientId;

  @HiveField(2)
  final String type; // e.g., 'Retina', 'Glaucoma'

  @HiveField(3)
  final double confidence; // 0.0 - 1.0

  @HiveField(4)
  final bool hasCriticalFinding;

  @HiveField(5)
  final String result;

  @HiveField(6)
  final DateTime timestamp;

  DiagnosticReport({
    required this.id,
    required this.patientId,
    required this.type,
    required this.confidence,
    required this.hasCriticalFinding,
    required this.result,
    required this.timestamp,
  });
}
