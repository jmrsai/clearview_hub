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
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';

class SaccadicTrainerScreen extends StatefulWidget {
  final String patientId;
  const SaccadicTrainerScreen({super.key, required this.patientId});

  @override
  State<SaccadicTrainerScreen> createState() => _SaccadicTrainerScreenState();
}

class _SaccadicTrainerScreenState extends State<SaccadicTrainerScreen> {
  late SaccadicGame _game;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _game = SaccadicGame(onGameOver: _onGameOver);
  }

  void _onGameOver(int score) {
    setState(() => _isRunning = false);
    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'saccadic_trainer',
      'duration_seconds': 60,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Score: $score',
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise Complete! Score: $score')),
      );
    }
  }

  void _startGame() {
    setState(() {
      _isRunning = true;
      _game = SaccadicGame(onGameOver: _onGameOver);
      _game.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Saccadic Trainer')),
      body: Stack(
        children: [
          GameWidget(game: _game),
          if (!_isRunning)
            Center(
              child: AdaptiveCard(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, size: 64, color: AppColors.cyan),
                    const SizedBox(height: 16),
                    Text('Fast Tracking', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Follow the dots as they appear. Move only your eyes, not your head.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _startGame();
                      },
                      child: const Text('Start Trainer'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SaccadicGame extends FlameGame with TapCallbacks {
  final Function(int) onGameOver;
  int score = 0;
  double timer = 60.0;
  bool isRunning = false;
  late TextComponent scoreText;
  late TextComponent timerText;
  late TargetComponent currentTarget;

  SaccadicGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 40),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
    timerText = TextComponent(
      text: 'Time: 60s',
      position: Vector2(20, 70),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
    add(scoreText);
    add(timerText);
  }

  void start() {
    isRunning = true;
    _spawnTarget();
  }

  void _spawnTarget() {
    if (!isRunning) return;
    if (children.query<TargetComponent>().isNotEmpty) {
      remove(children.query<TargetComponent>().first);
    }
    
    final random = Random();
    final x = 50 + random.nextDouble() * (size.x - 100);
    final y = 150 + random.nextDouble() * (size.y - 300);
    
    currentTarget = TargetComponent(
      position: Vector2(x, y),
      onTap: () {
        score++;
        scoreText.text = 'Score: $score';
        _spawnTarget();
      },
    );
    add(currentTarget);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isRunning) return;

    timer -= dt;
    timerText.text = 'Time: ${timer.toInt()}s';

    if (timer <= 0) {
      isRunning = false;
      onGameOver(score);
    }
  }
}

class TargetComponent extends CircleComponent with TapCallbacks {
  final VoidCallback onTap;

  TargetComponent({required Vector2 position, required this.onTap})
      : super(
          radius: 25,
          position: position,
          anchor: Anchor.center,
          paint: Paint()
            ..color = AppColors.cyan
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        );

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
