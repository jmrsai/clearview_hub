import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EyeHealthTheme {
  // Eye protection colors (Low blue light)
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color wellnessGreen = Color(0xFF00C853);
  static const Color warningYellow = Color(0xFFFFD600);
  static const Color errorRed = Color(0xFFFF1744);
  static const Color surfaceWhite = Colors.white10;

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: accentCyan,
      secondary: wellnessGreen,
      surface: backgroundDark,
      error: errorRed,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: surfaceWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0F3460),
      secondary: wellnessGreen,
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF0F3460),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
