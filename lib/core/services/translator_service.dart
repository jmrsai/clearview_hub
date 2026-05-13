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

import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Translation service with language persistence.
class TranslatorService extends ChangeNotifier {
  TranslatorService._();
  static final TranslatorService instance = TranslatorService._();

  final GoogleTranslator _translator = GoogleTranslator();

  String _currentLanguageCode = 'en';
  String _currentLanguageName = 'English';

  String get currentLanguageCode => _currentLanguageCode;
  String get currentLanguageName => _currentLanguageName;

  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage('en', 'English', '🇺🇸'),
    SupportedLanguage('es', 'Español', '🇪🇸'),
    SupportedLanguage('fr', 'Français', '🇫🇷'),
    SupportedLanguage('de', 'Deutsch', '🇩🇪'),
    SupportedLanguage('ar', 'العربية', '🇸🇦'),
    SupportedLanguage('hi', 'हिन्दी', '🇮🇳'),
    SupportedLanguage('ta', 'தமிழ்', '🇮🇳'),
    SupportedLanguage('te', 'తెలుగు', '🇮🇳'),
    SupportedLanguage('ml', 'മലയാളം', '🇮🇳'),
    SupportedLanguage('zh', '中文', '🇨🇳'),
    SupportedLanguage('ja', '日本語', '🇯🇵'),
    SupportedLanguage('ko', '한국어', '🇰🇷'),
    SupportedLanguage('pt', 'Português', '🇧🇷'),
    SupportedLanguage('ru', 'Русский', '🇷🇺'),
    SupportedLanguage('tr', 'Türkçe', '🇹🇷'),
    SupportedLanguage('id', 'Bahasa Indonesia', '🇮🇩'),
    SupportedLanguage('ur', 'اردو', '🇵🇰'),
    SupportedLanguage('bn', 'বাংলা', '🇧🇩'),
  ];

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguageCode = prefs.getString('language_code') ?? 'en';
    _currentLanguageName = prefs.getString('language_name') ?? 'English';
  }

  Future<void> setLanguage(SupportedLanguage lang) async {
    _currentLanguageCode = lang.code;
    _currentLanguageName = lang.name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', lang.code);
    await prefs.setString('language_name', lang.name);
    notifyListeners();
  }

  /// Translate a single string to the current language.
  Future<String> translate(String text) async {
    if (_currentLanguageCode == 'en') return text;
    try {
      final result = await _translator.translate(text, to: _currentLanguageCode);
      return result.text;
    } catch (e) {
      return text; // fallback to original
    }
  }

  /// Translate a list of strings efficiently.
  Future<List<String>> translateBatch(List<String> texts) async {
    if (_currentLanguageCode == 'en') return texts;
    final results = <String>[];
    for (final text in texts) {
      results.add(await translate(text));
    }
    return results;
  }

  bool get isEnglish => _currentLanguageCode == 'en';
}

class SupportedLanguage {
  final String code;
  final String name;
  final String flag;
  const SupportedLanguage(this.code, this.name, this.flag);
}
