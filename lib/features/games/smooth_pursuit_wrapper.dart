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
import 'package:flame/game.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import 'smooth_pursuit_flame_game.dart';

class SmoothPursuitWrapper extends StatefulWidget {
  final String patientId;
  const SmoothPursuitWrapper({super.key, required this.patientId});

  @override
  State<SmoothPursuitWrapper> createState() => _SmoothPursuitWrapperState();
}

class _SmoothPursuitWrapperState extends State<SmoothPursuitWrapper> {
  late SmoothPursuitFlameGame _game;
  int _currentScore = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _game = SmoothPursuitFlameGame(
      onScoreChanged: (score) {
        setState(() => _currentScore = score);
      },
      onGameOver: () {
        setState(() => _isGameOver = true);
        _saveSession();
      },
    );
  }

  void _saveSession() {
    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'smooth_pursuit_flame',
      'duration_seconds': 30,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Score: $_currentScore',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Flame Engine Pursuit')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: $_currentScore', style: Theme.of(context).textTheme.titleLarge),
                  if (_isGameOver)
                    const Text('GAME OVER', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: _isGameOver 
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Session Complete!', style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 16),
                        Text('Final Score: $_currentScore', style: const TextStyle(fontSize: 24, color: AppColors.cyan)),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: const Text('Return to Hub'),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GameWidget(game: _game),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
