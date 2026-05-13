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

import 'dart:async';
import 'dart:math';
import 'audit_service.dart';

enum EyeCondition { normal, cataract, glaucoma, retinopathy, uncertain }

class DiagnosticResult {
  final EyeCondition condition;
  final double confidence;
  final DateTime timestamp;
  final String imagePath;

  DiagnosticResult({
    required this.condition,
    required this.confidence,
    required this.timestamp,
    required this.imagePath,
  });

  String get conditionLabel => condition.name[0].toUpperCase() + condition.name.substring(1);
}

class AiDiagnosticService {
  AiDiagnosticService._();
  static final AiDiagnosticService instance = AiDiagnosticService._();

  /// Simulates AI inference on an eye image.
  /// Inspired by the ResNet50 model pattern found in 'eye-detect-app'.
  Future<DiagnosticResult> analyzeEyeImage(String imagePath) async {
    // In a real implementation, this would send the image to a FastAPI backend
    // or use a local TFLite model.
    await Future.delayed(const Duration(seconds: 2));

    await AuditService.instance.logDiagnostic(imagePath);

    final random = Random();
    
    // Weighted random for 'Normal' to simulate a screening environment
    EyeCondition condition;
    double confidence;
    
    int roll = random.nextInt(100);
    if (roll < 60) {
      condition = EyeCondition.normal;
      confidence = 0.85 + (random.nextDouble() * 0.14);
    } else if (roll < 75) {
      condition = EyeCondition.cataract;
      confidence = 0.70 + (random.nextDouble() * 0.25);
    } else if (roll < 90) {
      condition = EyeCondition.glaucoma;
      confidence = 0.65 + (random.nextDouble() * 0.30);
    } else {
      condition = EyeCondition.retinopathy;
      confidence = 0.60 + (random.nextDouble() * 0.35);
    }

    return DiagnosticResult(
      condition: condition,
      confidence: confidence,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
  }
}
