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

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central application configuration — loaded from .env at startup.
///
/// All API keys and secrets are sourced from the .env file,
/// which is EXCLUDED from version control via .gitignore.
///
/// Usage:
///   final key = AppConfig.geminiApiKey;
///
/// Setup:
///   1. Copy .env.example → .env
///   2. Replace placeholder values with real credentials
///   3. Never share or commit the .env file
class AppConfig {
  AppConfig._();

  static bool _initialized = false;

  /// Load the .env file. Call once in main() before runApp().
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await dotenv.load(fileName: '.env');
      _initialized = true;
      debugPrint('[AppConfig] Environment loaded successfully.');
      _validateRequiredKeys();
    } catch (e) {
      debugPrint('[AppConfig] WARNING: Could not load .env file: $e');
      debugPrint('[AppConfig] AI features will be disabled until key is configured.');
      _initialized = true; // Still mark as initialized to avoid crash loops
    }
  }

  // ── Key validation ────────────────────────────────────────────────────────

  static void _validateRequiredKeys() {
    if (geminiApiKey.isEmpty || geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      debugPrint(
        '[AppConfig] ⚠️  GEMINI_API_KEY not configured!\n'
        '  1. Get a free key at https://aistudio.google.com\n'
        '  2. Edit .env → GEMINI_API_KEY=your_key_here\n'
        '  AI screening, chatbot, and prescription OCR will show error until configured.',
      );
    } else {
      debugPrint('[AppConfig] ✅ Gemini API key configured (${geminiApiKey.substring(0, 4)}***)');
    }
  }

  // ── Gemini AI Config ──────────────────────────────────────────────────────

  /// The Gemini API key. Falls back to empty string if not set.
  static String get geminiApiKey =>
      dotenv.maybeGet('GEMINI_API_KEY') ?? '';

  /// Whether the Gemini API is properly configured.
  static bool get isGeminiConfigured =>
      geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE';

  /// The Gemini model to use.
  static String get geminiModel =>
      dotenv.maybeGet('GEMINI_MODEL') ?? 'gemini-1.5-flash';

  /// AI generation temperature (0.0–1.0).
  static double get geminiTemperature {
    final v = dotenv.maybeGet('GEMINI_TEMPERATURE');
    return double.tryParse(v ?? '') ?? 0.4;
  }

  /// Max tokens per AI response.
  static int get geminiMaxTokens {
    final v = dotenv.maybeGet('GEMINI_MAX_TOKENS');
    return int.tryParse(v ?? '') ?? 2048;
  }

  // ── Feature Flags ─────────────────────────────────────────────────────────

  /// Whether debug logging is enabled.
  static bool get debugMode => kDebugMode;

  /// App version string.
  static const String appVersion = '2.0.0';
  static const String buildNumber = '1';

  /// App name displayed to users.
  static const String appName = 'ClearView Hub';
  static const String appTagline = 'Global Vision Health Platform';

  // ── Medical Compliance ────────────────────────────────────────────────────

  /// WHO compliance statement used across screens.
  static const String whoComplianceStatement =
      'ClearView Hub tests are designed to align with WHO eye care standards. '
      'All results are for educational purposes only and are not a substitute '
      'for professional ophthalmic examination.';

  /// Emergency contact disclaimer.
  static const String emergencyDisclaimer =
      'If you experience sudden vision loss, eye pain, flashes of light, '
      'or a curtain across your vision — seek emergency medical care immediately.';
}
