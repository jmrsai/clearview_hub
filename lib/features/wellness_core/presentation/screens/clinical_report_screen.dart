import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ai_engine/domain/global_wellness_engine.dart';
import '../../../../core/compliance/services/report_export_service.dart';

class ClinicalReportScreen extends ConsumerWidget {
  const ClinicalReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalWellnessEngineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Clinical Eye Report'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.summarize, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 24),
            const Text(
              'Your Medical Report is Ready',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Generate a formal PDF report of your eye strain, posture, and blink metrics to share with your Optometrist or primary care physician.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.share),
                label: const Text(
                  'Generate & Share PDF',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await ReportExportService.generateAndShareClinicalReport(
                    eyeStrainScore: state.eyeStrainScore,
                    mentalFatigueScore: state.mentalFatigueIndex,
                    postureHealth: state.postureHealth,
                    recommendation: state.recommendation,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
