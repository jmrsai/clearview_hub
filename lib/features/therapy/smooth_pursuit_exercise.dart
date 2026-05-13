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

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';

enum PursuitPattern { infinity, circular, zigzag }

class SmoothPursuitExercise extends StatefulWidget {
  final String patientId;
  const SmoothPursuitExercise({super.key, required this.patientId});

  @override
  State<SmoothPursuitExercise> createState() => _SmoothPursuitExerciseState();
}

class _SmoothPursuitExerciseState extends State<SmoothPursuitExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  PursuitPattern _pattern = PursuitPattern.infinity;
  bool _isRunning = false;
  final int _durationSeconds = 60;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTest() {
    setState(() {
      if (_isRunning) {
        _stopTest();
      } else {
        _startTest();
      }
    });
  }

  void _startTest() {
    _isRunning = true;
    _startTime = DateTime.now();
    _controller.repeat();
    Future.delayed(Duration(seconds: _durationSeconds), () {
      if (mounted && _isRunning) _stopTest();
    });
  }

  Future<void> _stopTest() async {
    if (!_isRunning) return;
    _isRunning = false;
    _controller.stop();

    // Save session
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    await DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'smooth_pursuit_${_pattern.name}',
      'duration_seconds': elapsed,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Pattern: ${_pattern.name}',
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session completed: $elapsed seconds')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Smooth Pursuit')),
      body: Stack(
        children: [
          if (_isRunning)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pos = _getOffset(_controller.value);
                return Center(
                  child: Transform.translate(
                    offset: pos,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.6),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          if (!_isRunning)
            Center(
              child: AdaptiveCard(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.track_changes, size: 64, color: AppColors.cyan),
                    const SizedBox(height: 16),
                    Text('Follow the Dot', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Keep your head still and follow the moving target only with your eyes.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _patternSelector(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _toggleTest();
                      },
                      child: const Text('Start Exercise'),
                    ),
                  ],
                ),
              ),
            ),
          if (_isRunning)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _toggleTest();
                  },
                  label: const Text('Stop Session'),
                  icon: const Icon(Icons.stop),
                  backgroundColor: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _patternSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: PursuitPattern.values.map((p) {
        final active = _pattern == p;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(p.name.toUpperCase()),
            selected: active,
            onSelected: (val) {
              HapticFeedback.lightImpact();
              setState(() => _pattern = p);
            },
            selectedColor: AppColors.cyanDim,
            labelStyle: TextStyle(
              color: active ? AppColors.cyan : AppColors.textHint,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  Offset _getOffset(double t) {
    final size = MediaQuery.of(context).size;
    final w = size.width * 0.4;
    final h = size.height * 0.3;

    switch (_pattern) {
      case PursuitPattern.infinity:
        // Lemniscate of Gerono
        return Offset(
          math.sin(t * 2 * math.pi) * w,
          math.sin(t * 4 * math.pi) / 2 * h,
        );
      case PursuitPattern.circular:
        return Offset(
          math.cos(t * 2 * math.pi) * w,
          math.sin(t * 2 * math.pi) * w,
        );
      case PursuitPattern.zigzag:
        double x = (t < 0.5) ? (t * 4 - 1) : (3 - t * 4);
        return Offset(x * w, math.sin(t * 10 * math.pi) * 20);
    }
  }
}
