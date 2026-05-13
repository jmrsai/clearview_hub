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
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class SmoothPursuitFlameGame extends FlameGame with TapCallbacks {
  late TargetComponent target;
  int score = 0;
  int timeLeft = 30;
  double timeElapsed = 0;
  
  final Function(int) onScoreChanged;
  final Function() onGameOver;

  SmoothPursuitFlameGame({
    required this.onScoreChanged,
    required this.onGameOver,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add the moving target
    target = TargetComponent(
      position: size / 2,
      onTargetTapped: _handleTargetTapped,
    );
    add(target);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    timeElapsed += dt;
    if (timeElapsed >= 1.0) {
      timeElapsed = 0;
      timeLeft--;
      if (timeLeft <= 0) {
        pauseEngine();
        onGameOver();
      }
    }
  }

  void _handleTargetTapped() {
    score += 10;
    onScoreChanged(score);
    
    // Create a particle explosion effect on tap
    final random = Random();
    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 20,
          lifespan: 0.5,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: Vector2(0, 100),
              speed: Vector2(
                (random.nextDouble() - 0.5) * 400,
                (random.nextDouble() - 0.5) * 400,
              ),
              position: target.position.clone(),
              child: CircleParticle(
                radius: 4.0,
                paint: Paint()..color = const Color(0xFF00D4FF), // AppColors.cyan
              ),
            );
          },
        ),
      ),
    );
    
    // Respawn target in a random location
    target.position = Vector2(
      random.nextDouble() * (size.x - target.radius * 2) + target.radius,
      random.nextDouble() * (size.y - target.radius * 2) + target.radius,
    );
    
    // Increase speed slightly
    target.velocity.scale(1.1);
  }
}

class TargetComponent extends PositionComponent with TapCallbacks {
  final VoidCallback onTargetTapped;
  late Vector2 velocity;
  final double radius = 30.0;
  final Random _random = Random();
  
  TargetComponent({required super.position, required this.onTargetTapped}) : super(size: Vector2.all(60.0), anchor: Anchor.center) {
    // Initial random velocity
    double angle = _random.nextDouble() * 2 * pi;
    double speed = 150.0;
    velocity = Vector2(cos(angle) * speed, sin(angle) * speed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(velocity * dt);
    
    // Bounce off edges
    final gameSize = (findGame()! as SmoothPursuitFlameGame).size;
    if (position.x - radius < 0) {
      position.x = radius;
      velocity.x = -velocity.x;
    } else if (position.x + radius > gameSize.x) {
      position.x = gameSize.x - radius;
      velocity.x = -velocity.x;
    }
    
    if (position.y - radius < 0) {
      position.y = radius;
      velocity.y = -velocity.y;
    } else if (position.y + radius > gameSize.y) {
      position.y = gameSize.y - radius;
      velocity.y = -velocity.y;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFF00D4FF);
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    
    // Inner dot for focus
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(radius, radius), radius / 3, innerPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTargetTapped();
    super.onTapDown(event);
  }
}
