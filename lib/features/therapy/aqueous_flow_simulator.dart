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
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../core/theme/app_colors.dart';

class AqueousFlowSimulator extends StatefulWidget {
  const AqueousFlowSimulator({super.key});

  @override
  State<AqueousFlowSimulator> createState() => _AqueousFlowSimulatorState();
}

class _AqueousFlowSimulatorState extends State<AqueousFlowSimulator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FlowParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 20; i++) {
      _particles.add(FlowParticle(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.update(_controller.value);
        }
        return CustomPaint(
          painter: EyeFlowPainter(_particles),
          child: Container(),
        );
      },
    );
  }
}

class FlowParticle {
  double progress = 0;
  final double speed;
  final double offset;
  final math.Random random;

  FlowParticle(this.random)
      : speed = 0.5 + random.nextDouble() * 0.5,
        offset = random.nextDouble() * 2 * math.pi;

  void update(double globalProgress) {
    progress = (globalProgress * speed + offset / (2 * math.pi)) % 1.0;
  }
}

class EyeFlowPainter extends CustomPainter {
  final List<FlowParticle> particles;

  EyeFlowPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Draw Eye Outline
    final eyePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, eyePaint);

    // Draw Cornea (Arch)
    final corneaPath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2 - 0.5, 1.0);
    canvas.drawPath(corneaPath, eyePaint..color = AppColors.cyan.withValues(alpha: 0.5));

    // Draw Iris
    final irisPaint = Paint()
      ..color = AppColors.violet.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    canvas.drawLine(
      center + Offset(-radius * 0.3, -radius * 0.2),
      center + Offset(-radius * 0.1, -radius * 0.2),
      irisPaint,
    );
    canvas.drawLine(
      center + Offset(radius * 0.1, -radius * 0.2),
      center + Offset(radius * 0.3, -radius * 0.2),
      irisPaint,
    );

    // Draw Lens
    final lensPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: center + const Offset(0, 40), width: radius * 0.6, height: radius * 0.3),
      lensPaint,
    );

    // Draw Particles (Aqueous Humor)
    final particlePaint = Paint()..color = AppColors.cyan;
    
    for (var p in particles) {
      // Simple path: Ciliary Body -> Posterior Chamber -> Pupil -> Anterior Chamber -> Drainage
      Offset pos;
      if (p.progress < 0.3) {
        // Posterior Chamber (behind iris)
        double t = p.progress / 0.3;
        pos = Offset(
          ui.lerpDouble(-radius * 0.4, -radius * 0.05, t)!,
          ui.lerpDouble(20, -radius * 0.15, t)!,
        );
      } else if (p.progress < 0.6) {
        // Through Pupil to Anterior Chamber
        double t = (p.progress - 0.3) / 0.3;
        pos = Offset(
          ui.lerpDouble(-radius * 0.05, radius * 0.2, t)!,
          ui.lerpDouble(-radius * 0.15, -radius * 0.5, t)!,
        );
      } else {
        // Towards Drainage Angle
        double t = (p.progress - 0.6) / 0.4;
        pos = Offset(
          ui.lerpDouble(radius * 0.2, radius * 0.4, t)!,
          ui.lerpDouble(-radius * 0.5, -radius * 0.1, t)!,
        );
      }
      
      canvas.drawCircle(center + pos, 3, particlePaint..color = AppColors.cyan.withValues(alpha: 1.0 - p.progress));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
