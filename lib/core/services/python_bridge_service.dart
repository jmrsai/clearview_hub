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
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class PythonBridgeService {
  PythonBridgeService._();
  static final PythonBridgeService instance = PythonBridgeService._();

  static const MethodChannel _channel = MethodChannel('com.clearview.hub/python_bridge');

  Future<String> getPythonVersion() async {
    try {
      final String version = await _channel.invokeMethod('get_python_version');
      return version;
    } on PlatformException catch (e) {
      debugPrint("Failed to get Python version: '${e.message}'.");
      return "Unknown";
    }
  }

  Future<Map<String, dynamic>> analyzeVisualData(List<Map<String, dynamic>> patients) async {
    try {
      final dataJson = jsonEncode({'patients': patients});
      final String responseStr = await _channel.invokeMethod('analyze_visual_data', {'data_json': dataJson});
      return jsonDecode(responseStr) as Map<String, dynamic>;
    } on PlatformException catch (e) {
      debugPrint("Python Analysis Error: '${e.message}'.");
      return {'status': 'error', 'message': e.message};
    }
  }
}
