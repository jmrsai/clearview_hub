/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import '../database/database_helper.dart';
import 'gemini_service.dart';

class AiVisionInsightsService {
  AiVisionInsightsService._();
  static final AiVisionInsightsService instance = AiVisionInsightsService._();

  Future<String> generateSummary(String patientId) async {
    final results = await DatabaseHelper.instance.getVisionTestsForPatient(patientId);
    if (results.isEmpty) return 'No diagnostic data available for AI analysis yet.';

    final latestResults = results.take(10).toList();
    final dataSummary = latestResults.map((r) {
      return '- ${r.testType}: ${r.performedAt.toIso8601String()} '
          'Score: ${r.correctAnswers}/${r.totalQuestions} '
          'Acuity: ${r.acuityLeft}/${r.acuityRight} '
          'Notes: ${r.notes ?? "N/A"}';
    }).join('\n');

    final prompt = '''
Analyze the following vision test history for patient $patientId and provide a concise clinical insight summary (approx 100 words).
Identify any trends (improvement or decline), risk areas, and recommended next steps for the physician.

VISION TEST HISTORY:
$dataSummary

FORMAT:
- **Summary**: General status
- **Trends**: Improvement or decline observed
- **Recommendations**: Next steps
''';

    return GeminiService.instance.generateResponse(prompt);
  }
}
