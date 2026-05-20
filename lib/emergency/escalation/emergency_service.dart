import 'package:url_launcher/url_launcher.dart';

enum EmergencyType {
  suddenVisionLoss,
  retinalDetachment,
  eyeTrauma,
  chemicalExposure,
  severePain,
}

class EmergencyService {
  /// Escalate a critical symptom to emergency services or a doctor
  Future<void> escalateEmergency(EmergencyType type) async {
    final message = _getEmergencyMessage(type);
    print('EMERGENCY ESCALATION: $message');

    // In a real app, this would trigger an immediate call or SMS to emergency services/doctor
    // For now, we simulate launching the phone dialer
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '911', // Generic emergency number
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  String _getEmergencyMessage(EmergencyType type) {
    switch (type) {
      case EmergencyType.suddenVisionLoss:
        return 'CRITICAL: Sudden vision loss detected. Immediate medical attention required.';
      case EmergencyType.retinalDetachment:
        return 'CRITICAL: Symptoms of retinal detachment detected. Risk of permanent vision loss.';
      case EmergencyType.eyeTrauma:
        return 'URGENT: Eye trauma detected. Please seek immediate care.';
      case EmergencyType.chemicalExposure:
        return 'URGENT: Chemical exposure to eye. Rinse immediately and seek help.';
      case EmergencyType.severePain:
        return 'URGENT: Severe eye pain reported. Potential acute glaucoma or infection.';
    }
  }

  /// Automated detection of critical keywords in symptom checker
  bool containsCriticalSymptoms(String text) {
    final criticalKeywords = [
      'blindness',
      'blind',
      'sudden',
      'detached',
      'chemical',
      'acid',
      'bleeding',
      'intense pain',
    ];
    return criticalKeywords.any(
      (keyword) => text.toLowerCase().contains(keyword),
    );
  }
}
