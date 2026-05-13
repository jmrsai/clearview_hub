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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service for communicating with the local FastAPI Python backend.
class PythonApiService {
  PythonApiService._();
  static final PythonApiService instance = PythonApiService._();

  // Use 10.0.2.2 for Android Emulator, otherwise localhost
  static final String _baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8000'
      : 'http://127.0.0.1:8000';

  static final String _telemetryUrl = defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8001'
      : 'http://127.0.0.1:8001';

  Future<bool> checkHealth() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/')).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('Python Backend Offline: $e');
      return false;
    }
  }

  /// Send a chat message to the local NLP model for symptom checking.
  Future<Map<String, dynamic>> chatMedical(String message) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/chat/medical'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return {'response': 'Error: Server returned ${res.statusCode}', 'is_emergency': false};
    } catch (e) {
      debugPrint('Chat Medical Error: $e');
      return {'response': 'Error connecting to AI Brain. Make sure the Python backend is running.', 'is_emergency': false};
    }
  }

  /// Triggers a MiroFish-style multi-agent swarm debate on patient symptoms.
  Future<Map<String, dynamic>> runSwarmDiagnosis(String symptoms) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/analyze/swarm'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'symptoms': symptoms}),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return {'status': 'error', 'message': 'Server error: ${res.statusCode}'};
    } catch (e) {
      debugPrint('Swarm API Error: $e');
      return {'status': 'error', 'message': 'Connection to Mirror Fish Swarm failed.'};
    }
  }

  /// Upload an image to the Python ML backend for Retinal or Skin analysis
  Future<Map<String, dynamic>> analyzeEye(String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/analyze/eye'));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'status': 'error', 'message': 'Server returned ${response.statusCode}'};
    } catch (e) {
      debugPrint('Analyze Eye Error: $e');
      return {'status': 'error', 'message': 'Connection failed'};
    }
  }

  /// Sends a camera frame to the Telemetry Engine for gaze and openness analysis.
  Future<Map<String, dynamic>> analyzeFrame(Uint8List bytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_telemetryUrl/analyze-frame'));
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'frame.jpg',
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'status': 'error', 'message': 'Telemetry Engine returned ${response.statusCode}'};
    } catch (e) {
      debugPrint('Analyze Frame Error: $e');
      return {'status': 'error', 'message': 'Connection to Telemetry Engine failed.'};
    }
  }
}
