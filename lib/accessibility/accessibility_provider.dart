import 'package:flutter/material.dart';

class AccessibilitySettings {
  final bool isDarkMode;
  final double textScaleFactor;
  final bool highContrast;
  final bool colorBlindMode;

  const AccessibilitySettings({
    this.isDarkMode = true,
    this.textScaleFactor = 1.0,
    this.highContrast = false,
    this.colorBlindMode = false,
  });

  AccessibilitySettings copyWith({
    bool? isDarkMode,
    double? textScaleFactor,
    bool? highContrast,
    bool? colorBlindMode,
  }) {
    return AccessibilitySettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      highContrast: highContrast ?? this.highContrast,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
    );
  }
}

class AccessibilityProvider extends ChangeNotifier {
  AccessibilitySettings _settings = const AccessibilitySettings();
  AccessibilitySettings get settings => _settings;

  void toggleDarkMode(bool value) {
    _settings = _settings.copyWith(isDarkMode: value);
    notifyListeners();
  }

  void setTextScale(double value) {
    _settings = _settings.copyWith(textScaleFactor: value);
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    _settings = _settings.copyWith(highContrast: value);
    notifyListeners();
  }

  void toggleColorBlindMode(bool value) {
    _settings = _settings.copyWith(colorBlindMode: value);
    notifyListeners();
  }
}
