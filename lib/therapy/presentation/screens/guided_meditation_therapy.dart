import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';

class GuidedMeditationTherapyScreen extends StatefulWidget {
  const GuidedMeditationTherapyScreen({super.key});

  @override
  State<GuidedMeditationTherapyScreen> createState() => _GuidedMeditationTherapyScreenState();
}

class _GuidedMeditationTherapyScreenState extends State<GuidedMeditationTherapyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _instruction = "Inhale";
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _instruction = "Exhale");
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _instruction = "Inhale");
        _controller.forward();
      }
    });

    _controller.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _controller.stop();
        setState(() => _instruction = "Session Complete");
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Therapy Complete', style: TextStyle(color: Colors.white)),
        content: const Text('Your stress levels should be lower now. Keep it up!', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Breathing Therapy'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white54, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.6),
                          blurRadius: 40,
                          spreadRadius: 20 * _scaleAnimation.value,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 64),
            Text(
              _instruction,
              style: const TextStyle(color: Colors.white, fontSize: 32, letterSpacing: 2),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
