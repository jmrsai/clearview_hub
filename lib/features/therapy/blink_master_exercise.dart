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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../core/services/blink_detection_service.dart';

class BlinkMasterExercise extends StatefulWidget {
  final String patientId;
  const BlinkMasterExercise({super.key, required this.patientId});

  @override
  State<BlinkMasterExercise> createState() => _BlinkMasterExerciseState();
}

class _BlinkMasterExerciseState extends State<BlinkMasterExercise> {
  double _moisture = 1.0;
  bool _isRunning = false;
  Timer? _timer;
  int _blinks = 0;

  void _start() async {
    setState(() {
      _isRunning = true;
      _moisture = 1.0;
      _blinks = 0;
    });
    
    await BlinkDetectionService.instance.start();
    BlinkDetectionService.instance.addBlinkListener(_onBlink);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _moisture -= 0.005; // Slightly slower depletion for AI mode
        if (_moisture <= 0) {
          _moisture = 0;
          _stop();
        }
      });
    });
  }

  void _stop() async {
    _timer?.cancel();
    BlinkDetectionService.instance.removeBlinkListener(_onBlink);
    await BlinkDetectionService.instance.stop();
    
    if (mounted) setState(() => _isRunning = false);
    
    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'blink_master_ai',
      'duration_seconds': 0,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Blinks: $_blinks (AI Detected)',
    });
  }

  void _onBlink() {
    if (!_isRunning) return;
    setState(() {
      _blinks++;
      _moisture = ((_moisture + 0.3) > 1.0) ? 1.0 : (_moisture + 0.3);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = Color.lerp(AppColors.error, AppColors.cyan, _moisture)!;

    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Blink Master')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning) ...[
                const Icon(Icons.remove_red_eye, size: 80, color: AppColors.cyan),
                const SizedBox(height: 24),
                Text('Prevent Dry Eyes', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 12),
                const Text(
                  'Your virtual eye will get dry over time. Consciously blink to keep it lubricated!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _start();
                  },
                  child: const Text('Start Challenge'),
                ),
              ] else ...[
                Text('Moisture Level', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _moisture,
                        strokeWidth: 12,
                        color: statusColor,
                        backgroundColor: AppColors.glassFill,
                      ),
                    ),
                    Icon(
                      _moisture < 0.3 ? Icons.warning_amber_rounded : Icons.opacity,
                      size: 60,
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text('Blinks: $_blinks', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 60),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.cyan, size: 16),
                      const SizedBox(width: 8),
                      Text('AI BLINK DETECTION ACTIVE', 
                          style: TextStyle(color: AppColors.cyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _stop();
                  },
                  child: const Text('End Session', 
                    style: TextStyle(color: AppColors.error)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
