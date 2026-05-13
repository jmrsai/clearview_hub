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

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'gemini_service.dart';

/// OCR service for scanning prescription images and extracting medication data.
class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from camera or gallery and extract text.
  Future<OcrResult?> scanPrescription({bool fromCamera = true}) async {
    try {
      final XFile? image = fromCamera
          ? await _picker.pickImage(source: ImageSource.camera, imageQuality: 90)
          : await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);

      if (image == null) return null;

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognized = await _recognizer.processImage(inputImage);

      final rawText = recognized.blocks
          .map((b) => b.text)
          .join('\n')
          .trim();

      if (rawText.isEmpty) {
        return OcrResult(rawText: '', parsedMedicines: [], error: 'No text found in image');
      }

      // Use Gemini to parse the OCR text into structured medication data
      final parsed = await GeminiService.instance.parsePrescription(rawText);

      return OcrResult(
        rawText: rawText,
        parsedMedicines: _extractMedicines(parsed),
        doctorName: parsed['doctor'] as String?,
        prescriptionDate: parsed['date'] as String?,
      );
    } catch (e) {
      return OcrResult(rawText: '', parsedMedicines: [], error: e.toString());
    }
  }

  List<ParsedMedicine> _extractMedicines(Map<String, dynamic> parsed) {
    try {
      final raw = parsed['raw'] as String? ?? '{}';
      // Simple JSON parsing for the medicines array
      // In production, use dart:convert json.decode
      if (raw.contains('"medicines"')) {
        // Extract medicine blocks from raw JSON
        final medicines = <ParsedMedicine>[];
        final nameMatches = RegExp(r'"name":\s*"([^"]+)"').allMatches(raw);
        final dosageMatches = RegExp(r'"dosage":\s*"([^"]+)"').allMatches(raw);
        final freqMatches = RegExp(r'"frequency":\s*"([^"]+)"').allMatches(raw);
        final durationMatches = RegExp(r'"duration_days":\s*(\d+)').allMatches(raw);

        final names = nameMatches.map((m) => m.group(1) ?? '').toList();
        final dosages = dosageMatches.map((m) => m.group(1) ?? '').toList();
        final freqs = freqMatches.map((m) => m.group(1) ?? 'once_daily').toList();
        final durations = durationMatches.map((m) => int.tryParse(m.group(1) ?? '7') ?? 7).toList();

        for (int i = 0; i < names.length; i++) {
          medicines.add(ParsedMedicine(
            name: names[i],
            dosage: i < dosages.length ? dosages[i] : '',
            frequency: i < freqs.length ? freqs[i] : 'once_daily',
            durationDays: i < durations.length ? durations[i] : 7,
          ));
        }
        return medicines;
      }
    } catch (_) {}
    return [];
  }

  void dispose() {
    _recognizer.close();
  }
}

class OcrResult {
  final String rawText;
  final List<ParsedMedicine> parsedMedicines;
  final String? doctorName;
  final String? prescriptionDate;
  final String? error;

  OcrResult({
    required this.rawText,
    required this.parsedMedicines,
    this.doctorName,
    this.prescriptionDate,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasMedicines => parsedMedicines.isNotEmpty;
}

class ParsedMedicine {
  final String name;
  final String dosage;
  final String frequency;
  final int durationDays;

  ParsedMedicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
  });

  List<String> get defaultTimes {
    switch (frequency) {
      case 'twice_daily': return ['08:00', '20:00'];
      case 'thrice_daily': return ['08:00', '14:00', '20:00'];
      case 'four_times_daily': return ['08:00', '12:00', '16:00', '20:00'];
      default: return ['08:00'];
    }
  }
}
