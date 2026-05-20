import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../compliance_manager.dart';

class MedicalConsentScreen extends StatefulWidget {
  const MedicalConsentScreen({super.key});

  @override
  State<MedicalConsentScreen> createState() => _MedicalConsentScreenState();
}

class _MedicalConsentScreenState extends State<MedicalConsentScreen> {
  bool _agreedToDisclaimer = false;
  bool _agreedToLocalData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Medical Disclaimer & Privacy'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Force them to read this
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.security, size: 64, color: Colors.cyanAccent),
              const SizedBox(height: 24),
              const Text(
                'Before we begin...',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'ClearView Hub uses your device sensors (camera, accelerometer, etc.) to monitor your digital wellness and eye strain.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEDICAL DISCLAIMER',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This application is for informational and wellness purposes only. It is NOT a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or qualified health provider with any questions you may have regarding a medical condition.',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
                value: _agreedToDisclaimer,
                onChanged: (val) {
                  setState(() {
                    _agreedToDisclaimer = val ?? false;
                  });
                },
                title: const Text('I understand this is not a medical diagnosis tool.'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.cyanAccent,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _agreedToLocalData,
                onChanged: (val) {
                  setState(() {
                    _agreedToLocalData = val ?? false;
                  });
                },
                title: const Text('I agree to the local processing of my biometric data (100% stored on device).'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.cyanAccent,
                contentPadding: EdgeInsets.zero,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (_agreedToDisclaimer && _agreedToLocalData)
                      ? () async {
                          await ComplianceManager().grantConsent();
                          if (context.mounted) {
                            context.go('/dashboard');
                          }
                        }
                      : null, // Disabled until checked
                  child: const Text(
                    'I Agree, Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
