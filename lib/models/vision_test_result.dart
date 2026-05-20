import 'package:hive/hive.dart';

part 'vision_test_result.g.dart';

@HiveType(typeId: 2, adapterName: 'VisionTestResultAdapter')
class VisionTestResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String testType;

  @HiveField(4)
  final Map<String, dynamic> results;

  @HiveField(5)
  final double eyeFatigueScore;

  @HiveField(6)
  final bool isSynced;

  VisionTestResult({
    required this.id,
    required this.patientId,
    required this.date,
    required this.testType,
    required this.results,
    required this.eyeFatigueScore,
    this.isSynced = false,
  });
}
