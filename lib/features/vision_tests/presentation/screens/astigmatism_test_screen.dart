import 'dart:math';
import 'package:flutter/material.dart';

class AstigmatismTestScreen extends StatefulWidget {
  const AstigmatismTestScreen({super.key});

  @override
  State<AstigmatismTestScreen> createState() => _AstigmatismTestScreenState();
}

class _AstigmatismTestScreenState extends State<AstigmatismTestScreen> {
  int _step = 1; // 1 = Left Eye covered, 2 = Right Eye covered

  void _handleResult(bool hasDistortion) {
    if (_step == 1) {
      setState(() {
        _step = 2;
      });
    } else {
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151B2B),
        title: const Text('Test Complete', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your astigmatism results have been recorded in your clinical profile.\nIf any lines appeared significantly darker or sharper than others, please consult an ophthalmologist.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Back to dashboard
            },
            child: const Text('Done', style: TextStyle(color: Color(0xFF00E5FF))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Astigmatism Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _step == 1 ? 'Cover your RIGHT eye.' : 'Cover your LEFT eye.',
                style: const TextStyle(fontSize: 22, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Focus on the center circle. Do some lines appear darker, sharper, or thicker than others?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const Spacer(),
            // Fan Dial Canvas
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: AstigmatismDialPainter(),
              ),
            ),
            const Spacer(),
            // Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => _handleResult(true),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('Yes, some lines look different', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _handleResult(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('No, all lines look uniform', style: TextStyle(color: Color(0xFF0A0E1A), fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AstigmatismDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw lines every 15 degrees
    for (int i = 0; i < 180; i += 15) {
      double angle = i * pi / 180;
      // Start slightly away from center
      double innerRadius = 20.0;
      
      Offset start = Offset(
        center.dx + innerRadius * cos(angle),
        center.dy + innerRadius * sin(angle),
      );
      
      Offset end = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      
      // Draw the line in both directions
      Offset oppositeStart = Offset(
        center.dx - innerRadius * cos(angle),
        center.dy - innerRadius * sin(angle),
      );
      
      Offset oppositeEnd = Offset(
        center.dx - radius * cos(angle),
        center.dy - radius * sin(angle),
      );

      canvas.drawLine(start, end, paint);
      canvas.drawLine(oppositeStart, oppositeEnd, paint);
    }

    // Draw center target
    final targetPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8.0, targetPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
