import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';

class PalmingExerciseScreen extends StatefulWidget {
  const PalmingExerciseScreen({super.key});

  @override
  State<PalmingExerciseScreen> createState() => _PalmingExerciseScreenState();
}

class _PalmingExerciseScreenState extends State<PalmingExerciseScreen> {
  int _secondsRemaining = 60; // 1 min palming
  bool _isActive = false;
  Timer? _timer;

  void _startExercise() {
    setState(() => _isActive = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _endExercise();
      }
    });
  }

  void _endExercise() {
    _timer?.cancel();
    setState(() => _isActive = false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Exercise Complete', style: TextStyle(color: Colors.white)),
        content: const Text('Your eyes should feel more relaxed. Remember to blink often!', style: TextStyle(color: Colors.white70)),
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palming Exercise'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pan_tool, size: 80, color: AppColors.secondary),
              const SizedBox(height: 24),
              const Text(
                'Rub your hands together to warm them, then gently place them over your closed eyes without pressing.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              if (_isActive)
                Text(
                  '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  onPressed: _startExercise,
                  child: const Text('Start 1 Min Palming', style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
