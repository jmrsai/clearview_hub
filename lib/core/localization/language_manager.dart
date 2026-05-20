import 'package:flutter/material.dart';

class LanguageManager {
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'ar', 'name': 'العربية'},
  ];

  // Placeholder for when intl / easy_localization is fully wired in
  static String translate(String key) {
    // Return key for now, real implementation would look up localized strings
    return key;
  }
}
