import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0, adapterName: 'PatientAdapter')
class Patient {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime dateOfBirth;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final List<String> medicalHistory;

  @HiveField(5)
  final bool hasGlaucomaHistory;

  @HiveField(6)
  final bool hasDiabetesHistory;

  @HiveField(7)
  final DateTime? lastScreeningDate;

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    this.medicalHistory = const [],
    this.hasGlaucomaHistory = false,
    this.hasDiabetesHistory = false,
    this.lastScreeningDate,
  });
}
