import 'package:hive/hive.dart';
import '../../models/patient.dart';

class LocalPatientRecordsService {
  static const String _boxName = 'patient_records';

  Future<void> savePatient(Patient patient) async {
    final box = await Hive.openBox<Patient>(_boxName);
    await box.put(patient.id, patient);
  }

  Future<Patient?> getPatient(String id) async {
    final box = await Hive.openBox<Patient>(_boxName);
    return box.get(id);
  }

  Future<List<Patient>> getAllPatients() async {
    final box = await Hive.openBox<Patient>(_boxName);
    return box.values.toList();
  }

  Future<void> deletePatient(String id) async {
    final box = await Hive.openBox<Patient>(_boxName);
    await box.delete(id);
  }
}
