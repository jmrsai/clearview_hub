import 'package:flutter/material.dart';

/// Design Tokens for EyeVerse AI.
/// These colors are chosen to be calm, highly accessible (WCAG compliant),
/// and optimized for users with visual impairments.
class AppColors {
  // Primary (Calm Blue - Medical Trust)
  static const Color primary = Color(0xFF0F3460);
  static const Color primaryLight = Color(0xFF1A457B);
  static const Color primaryDark = Color(0xFF081C36);

  // Secondary (Teal - Tech/AI feel)
  static const Color secondary = Color(0xFF00ADB5);
  static const Color secondaryLight = Color(0xFF33BDC3);
  static const Color secondaryDark = Color(0xFF00797F);
  static const Color accent = Color(0xFF00E5FF); // Electric Cyan


  // Backgrounds (Dark Mode First - reduces eye strain)
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color surfaceDark = Color(0xFF151B2B);
  static const Color surfaceElevated = Color(0xFF1E2638);

  // Text Colors (High Contrast)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3B8);
  static const Color textDisabled = Color(0xFF757575);

  // Semantic / Feedback
  static const Color error = Color(0xFFFF4C4C); // WCAG AAA compliant red on dark
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD600);
  static const Color info = Color(0xFF29B6F6);

  // Accessibility Color Blindness Modes (Protanopia/Deuteranopia friendly palette)
  static const Color colorBlindSafePrimary = Color(0xFF0072B2);
  static const Color colorBlindSafeSecondary = Color(0xFFD55E00);

  // Glassmorphism effects
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
}
