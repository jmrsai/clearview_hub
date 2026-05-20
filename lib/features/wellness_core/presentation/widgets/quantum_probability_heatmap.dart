import 'dart:math';
import 'package:flutter/material.dart';

class QuantumProbabilityHeatmap extends StatefulWidget {
  final Map<String, double> quantumCorrelations;

  const QuantumProbabilityHeatmap({
    super.key,
    required this.quantumCorrelations,
  });

  @override
  State<QuantumProbabilityHeatmap> createState() => _QuantumProbabilityHeatmapState();
}

class _QuantumProbabilityHeatmapState extends State<QuantumProbabilityHeatmap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
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
        return CustomPaint(
          painter: _QuantumHeatmapPainter(
            quantumCorrelations: widget.quantumCorrelations,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _QuantumHeatmapPainter extends CustomPainter {
  final Map<String, double> quantumCorrelations;
  final double animationValue;

  _QuantumHeatmapPainter({
    required this.quantumCorrelations,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    // Base eye/retina representation
    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius, bgPaint);

    final random = Random(42); // Deterministic random for stable points

    quantumCorrelations.forEach((disease, probability) {
      if (probability > 0.3) {
        Color nodeColor;
        switch (disease) {
          case 'micro_aneurysm':
            nodeColor = Colors.redAccent;
            break;
          case 'optic_disc_cupping':
            nodeColor = Colors.cyanAccent;
            break;
          case 'corneal_tear':
            nodeColor = Colors.orangeAccent;
            break;
          default:
            nodeColor = Colors.purpleAccent;
        }

        // Draw multiple quantum "probability nodes" around the retina
        final numNodes = (probability * 10).toInt();
        for (int i = 0; i < numNodes; i++) {
          final angle = random.nextDouble() * 2 * pi;
          // Distance from center varies based on probability and animation pulse
          final distance = random.nextDouble() * maxRadius * 0.8 * (0.8 + 0.2 * animationValue);
          final dx = center.dx + distance * cos(angle);
          final dy = center.dy + distance * sin(angle);

          final nodePaint = Paint()
            ..color = nodeColor.withValues(alpha: (0.4 + 0.6 * animationValue) * probability)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
            
          canvas.drawCircle(Offset(dx, dy), 15 * probability * (1.0 + animationValue), nodePaint);
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant _QuantumHeatmapPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
