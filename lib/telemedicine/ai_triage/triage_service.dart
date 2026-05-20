import '../../models/diagnostic_report.dart';

class AiTriageService {
  /// Triages a patient's reported symptoms and AI scan results.
  /// Categorizes into: Routine, Urgent, Emergency.
  String determinePriority(DiagnosticReport report) {
    // In a real-world scenario, this uses complex decision trees or LLMs.
    if (report.hasCriticalFinding) return 'Emergency';
    if (report.confidence < 0.6) return 'Urgent (Doctor Review Required)';
    return 'Routine';
  }

  /// Recommends the type of specialist required based on the AI scan findings.
  String recommendSpecialist(DiagnosticReport report) {
    if (report.type == 'Retina') return 'Retinal Specialist';
    if (report.type == 'Glaucoma') return 'Glaucoma Specialist';
    return 'General Ophthalmologist';
  }
}
