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

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:clearview_hub/core/services/eye_tracking_service.dart';

class TargetAcquisitionGame extends FlameGame {
  late TargetComponent target;
  late GazeCursorComponent gazeCursor;
  final EyeTrackingService _eyeTrackingService = EyeTrackingService();

  int score = 0;
  int currentLevel = 1;
  double timeLeft = 60.0;
  double targetSizeMultiplier = 1.0;
  double scoreMultiplier = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF0A0E1A); // Dark Medical Theme Background

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize the target
    target = TargetComponent(this);
    add(target);

    // Initialize the gaze cursor
    gazeCursor = GazeCursorComponent();
    add(gazeCursor);

    // Listen to gaze data to update cursor
    _eyeTrackingService.gazeStream.listen((gazeData) {
      gazeCursor.position = Vector2(gazeData.x, gazeData.y);
      _checkHit();
        });
  }

  void _checkHit() {
    // If the gaze is within the target bounds
    if (target.toRect().contains(gazeCursor.position.toOffset())) {
      score += (10 * scoreMultiplier).toInt();
      
      // Level progression logic
      if (score >= 100 && currentLevel == 1) {
        _upgradeLevel(2, 0.75, 1.5, 45);
      } else if (score >= 250 && currentLevel == 2) {
        _upgradeLevel(3, 0.5, 2.0, 30);
      }
      
      target.spawnRandomly();
    }
  }

  void _upgradeLevel(int level, double sizeMult, double scoreMult, double extraTime) {
    currentLevel = level;
    targetSizeMultiplier = sizeMult;
    scoreMultiplier = scoreMult;
    timeLeft += extraTime;
    target.updateSize();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeLeft -= dt;
    if (timeLeft <= 0) {
      pauseEngine();
      // Game over logic
    }
  }
}

class TargetComponent extends PositionComponent with HasGameReference<TargetAcquisitionGame> {
  static const double targetSize = 60.0;
  final Random _random = Random();
  late final Paint _paint;

  TargetComponent(TargetAcquisitionGame game) : super(size: Vector2.all(targetSize)) {
    _paint = Paint()..color = const Color(0xFF36D1DC); // Medical Teal
    spawnRandomly(initial: true);
  }

  void updateSize() {
    size = Vector2.all(targetSize * game.targetSizeMultiplier);
  }

  void spawnRandomly({bool initial = false}) {
    if (!initial && game.size.x == 0) return;
    
    // Fallback size if not fully layout yet
    final screenWidth = game.size.x > 0 ? game.size.x : 500.0;
    final screenHeight = game.size.y > 0 ? game.size.y : 800.0;

    final x = _random.nextDouble() * (screenWidth - size.x);
    final y = _random.nextDouble() * (screenHeight - size.y);
    
    position = Vector2(x, y);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      _paint,
    );
  }
}

class GazeCursorComponent extends PositionComponent {
  late final Paint _paint;

  GazeCursorComponent() : super(size: Vector2.all(20.0)) {
    _paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      _paint,
    );
  }
}

// A simple Flutter Widget wrapper to launch the game
class TargetAcquisitionGameWidget extends StatelessWidget {
  const TargetAcquisitionGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Therapy: Target Practice'),
      ),
      body: GameWidget(
        game: TargetAcquisitionGame(),
        overlayBuilderMap: {
          'GameOver': (context, TargetAcquisitionGame game) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                color: Colors.black87,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Session Complete',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Score: ${game.score} · Level: ${game.currentLevel}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Return to Dashboard'),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
