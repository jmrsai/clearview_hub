import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Centralized Accessibility Service to enforce global a11y standards.
/// Handles screen reader announcements, haptic feedback patterns,
/// and dynamic text scaling overrides.
class AccessibilityService {
  
  /// Announces a message to Screen Readers (TalkBack/VoiceOver)
  static void announce(String message, {ui.Assertiveness announcementPriority = ui.Assertiveness.polite}) {
    SemanticsService.announce(message, TextDirection.ltr, assertiveness: announcementPriority);
  }

  /// Trigger medical-grade haptic feedback for critical alerts (e.g. eye strain)
  static Future<void> triggerAlertHaptic() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Helper to calculate accessible touch targets (Minimum 48x48 dp per WCAG)
  static double get minTouchTarget => 48.0;

  /// Inverts colors for specific low-vision modes if handled at app-level
  static Color getAccessibleContrastColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }
}

/// A wrapper to ensure all interactive elements have semantic labels.
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final VoidCallback onTap;

  const AccessibleButton({
    super.key, 
    required this.child, 
    required this.label, 
    this.hint, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minWidth: AccessibilityService.minTouchTarget,
            minHeight: AccessibilityService.minTouchTarget,
          ),
          child: child,
        ),
      ),
    );
  }
}
