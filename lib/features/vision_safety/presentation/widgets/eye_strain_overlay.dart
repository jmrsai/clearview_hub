import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../providers/vision_safety_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// A global overlay widget that should be placed high up in the widget tree (e.g. above Scaffold or MaterialApp builder).
/// It listens to AI proximity warnings and the 20-20-20 rule timer.
class EyeStrainOverlay extends ConsumerWidget {
  final Widget child;

  const EyeStrainOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBreak = ref.watch(twentyTwentyTwentyProvider);
    final isTooClose = ref.watch(proximityWarningProvider).value ?? false;

    return Stack(
      children: [
        child,
        
        // 1. Proximity Warning (Too close to screen)
        if (isTooClose && !showBreak)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'You are too close to the screen. Please move back to protect your eyes.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // 2. 20-20-20 Rule Break Overlay
        if (showBreak)
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10 * value, sigmaY: 10 * value),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      color: AppColors.primaryDark.withOpacity(0.8),
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.remove_red_eye, color: AppColors.secondary, size: 80),
                                const SizedBox(height: 24),
                                const Text(
                                  'Time for an Eye Break!',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Look at something 20 feet away for 20 seconds.',
                                  style: TextStyle(fontSize: 18, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.read(twentyTwentyTwentyProvider.notifier).dismissBreak();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primaryDark,
                                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                  ),
                                  child: const Text('Dismiss'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
