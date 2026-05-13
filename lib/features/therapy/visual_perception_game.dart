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
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';

class VisualPerceptionGame extends StatefulWidget {
  final String patientId;
  const VisualPerceptionGame({super.key, required this.patientId});

  @override
  State<VisualPerceptionGame> createState() => _VisualPerceptionGameState();
}

class _VisualPerceptionGameState extends State<VisualPerceptionGame> {
  bool _isRunning = false;
  int _score = 0;
  int _level = 1;
  Timer? _timer;
  int _timeLeft = 45;

  final Random _random = Random();
  late IconData _targetShape;
  final List<IconData> _gridShapes = [];
  
  final List<IconData> _availableShapes = [
    Icons.star, Icons.favorite, Icons.change_history, Icons.circle,
    Icons.square, Icons.hexagon, Icons.pentagon, Icons.diamond,
    Icons.cloud, Icons.water_drop, Icons.bolt, Icons.eco
  ];

  void _start() {
    setState(() {
      _isRunning = true;
      _score = 0;
      _level = 1;
      _timeLeft = 45;
    });
    _generateGrid();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _stop();
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    
    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'visual_perception',
      'duration_seconds': 45,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Score: $_score, Level: $_level',
    });
  }

  void _generateGrid() {
    _gridShapes.clear();
    
    // Select a target shape
    _targetShape = _availableShapes[_random.nextInt(_availableShapes.length)];
    
    // Grid size increases with level (max 36)
    int gridSize = min(16 + (_level * 4), 36);
    
    // Add one target
    _gridShapes.add(_targetShape);
    
    // Fill the rest with distractors
    for (int i = 0; i < gridSize - 1; i++) {
      IconData distractor;
      do {
        distractor = _availableShapes[_random.nextInt(_availableShapes.length)];
      } while (distractor == _targetShape);
      _gridShapes.add(distractor);
    }
    
    _gridShapes.shuffle();
  }

  void _onTapShape(IconData shape) {
    if (!_isRunning) return;
    
    setState(() {
      if (shape == _targetShape) {
        _score += 15;
        _level++;
        _timeLeft = min(_timeLeft + 3, 45); // Bonus time for correct answer
        _generateGrid();
      } else {
        _score = max(0, _score - 5);
        _timeLeft = max(0, _timeLeft - 2); // Penalty for wrong answer
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Visual Perception')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (!_isRunning) ...[
                const Spacer(),
                const Icon(Icons.grid_view, size: 80, color: AppColors.cyan),
                const SizedBox(height: 24),
                Text('Visual Memory & Search', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                const Text(
                  'Train your visual discrimination and memory by finding the target shape among distractors as quickly as possible. The grid gets harder as you level up!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textHint, fontSize: 16),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _start();
                  },
                  child: const Text('Start Challenge'),
                ),
                const Spacer(),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level: $_level', style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                    Text('Time: $_timeLeft', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _timeLeft <= 10 ? AppColors.error : AppColors.cyan)),
                    Text('Score: $_score', style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 24),
                AdaptiveCard(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      const Text('TARGET', style: TextStyle(letterSpacing: 2, fontSize: 12, color: AppColors.textHint)),
                      const SizedBox(height: 8),
                      Icon(_targetShape, size: 64, color: AppColors.primaryGradient.colors.last),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridShapes.length > 25 ? 6 : 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _gridShapes.length,
                    itemBuilder: (context, index) {
                      final shape = _gridShapes[index];
                      // Randomize rotation slightly for higher difficulty on advanced levels
                      final double rotation = _level > 5 ? (_random.nextDouble() * pi / 4) : 0;
                      
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _onTapShape(shape);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.glassFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: rotation,
                              child: Icon(shape, size: 32, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _stop();
                  }, 
                  child: const Text('End Session', style: TextStyle(color: AppColors.error))
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
