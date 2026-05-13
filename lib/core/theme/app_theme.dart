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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _buildTheme(Brightness.dark);
  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
    
    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.cyan,
            secondary: AppColors.violet,
            surface: AppColors.bgCard,
            error: AppColors.error,
            onPrimary: AppColors.bgDeep,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimary,
            onError: Colors.white,
          )
        : const ColorScheme.light(
            primary: AppColors.cyanDeep,
            secondary: AppColors.violet,
            surface: AppColors.bgLightCard,
            error: AppColors.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textLightPrimary,
            onError: Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? AppColors.bgDeep : AppColors.bgLight,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        displayMedium: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        displaySmall: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        titleLarge: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        titleMedium: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        titleSmall: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        bodyLarge: GoogleFonts.inter(
            fontSize: 14,
            letterSpacing: 0.2,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        bodyMedium: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 0.2,
            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
        bodySmall: GoogleFonts.inter(
            fontSize: 11,
            letterSpacing: 0.1,
            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
        labelLarge: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        labelMedium: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
        labelSmall: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
        iconTheme: IconThemeData(
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.glassFill : AppColors.bgLightCard,
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: isDark
              ? const BorderSide(color: AppColors.glassBorder, width: 1)
              : BorderSide.none,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.glassFill : AppColors.bgLightAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? const BorderSide(color: AppColors.glassBorder)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? const BorderSide(color: AppColors.glassBorder)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: isDark ? AppColors.cyan : AppColors.cyanDeep, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
            color: isDark ? AppColors.textHint : AppColors.textLightHint,
            fontSize: 13,
            letterSpacing: 0.1),
        labelStyle: GoogleFonts.inter(
            color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
            fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.cyan : AppColors.cyanDeep,
          foregroundColor: isDark ? AppColors.bgDeep : Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
          elevation: isDark ? 0 : 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.cyan : AppColors.cyanDeep,
          minimumSize: const Size(double.infinity, 48),
          side: BorderSide(color: isDark ? AppColors.cyan : AppColors.cyanDeep),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.glassFill : AppColors.bgLightAlt,
        selectedColor: isDark ? AppColors.cyanDim : AppColors.cyanDeep.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.inter(
            color: isDark ? AppColors.textPrimary : AppColors.textLightPrimary,
            fontSize: 11,
            letterSpacing: 0.1),
        side: isDark
            ? const BorderSide(color: AppColors.glassBorder)
            : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// A smooth, animated progress bar for data visualizations.
class AnimatedProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color? color;
  final double height;
  final String? label;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: value),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            return Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: val.clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (color ?? AppColors.cyan).withValues(alpha: 0.7),
                        color ?? AppColors.cyan,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: (color ?? AppColors.cyan).withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Adaptive container widget that behaves as Glass in Dark mode and a Material Card in Light mode.
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget content = Container(
      margin: margin,
      decoration: isDark
          ? BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.05),
                  blurRadius: 30,
                  spreadRadius: -10,
                )
              ],
            )
          : BoxDecoration(
              color: AppColors.bgLightCard,
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                )
              ],
            ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap!();
        },
        child: content,
      );
    }

    return content;
  }
}

/// Adaptive gradient background scaffold
class AdaptiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: isDark,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: isDark
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.bgDeep, AppColors.bgCard, AppColors.bgSurface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: body,
            )
          : body,
    );
  }
}

/// Reusable GlassCard (legacy support, now uses AdaptiveCard internally if needed or stays glass)
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AppColors.glassFill : null,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Gradient background scaffold (legacy support)
class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgDeep, Color(0xFF0D1B33), AppColors.bgDeep],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: body,
      ),
    );
  }
}
