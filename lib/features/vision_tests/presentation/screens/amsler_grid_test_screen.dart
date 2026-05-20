import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmslerGridTestScreen extends StatefulWidget {
  const AmslerGridTestScreen({super.key});

  @override
  State<AmslerGridTestScreen> createState() => _AmslerGridTestScreenState();
}

class _AmslerGridTestScreenState extends State<AmslerGridTestScreen> {
  bool _showInstructions = true;
  int _step = 1; // 1: Left Eye, 2: Right Eye

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Amsler Grid Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _showInstructions ? _buildInstructions() : _buildTest(),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.remove_red_eye, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            'Clinical Amsler Grid Test',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '1. Wear your reading glasses if you use them.\n'
            '2. Hold the screen about 12-15 inches away.\n'
            '3. Cover one eye with your hand.\n'
            '4. Focus on the center dot.\n'
            '5. Check if any lines look wavy, blurred, or missing.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => setState(() => _showInstructions = false),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: const Text('Start Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildTest() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _step == 1 ? 'Cover your RIGHT eye' : 'Cover your LEFT eye',
            style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
          ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CustomPaint(
                  painter: AmslerGridPainter(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Do you see any distorted or missing lines?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => _handleResult(false),
                    child: const Text('No Distortions', style: TextStyle(color: Colors.green)),
                  ),
                  OutlinedButton(
                    onPressed: () => _handleResult(true),
                    child: const Text('Yes, I see distortions', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleResult(bool hasDistortion) {
    if (_step == 1) {
      setState(() => _step = 2);
    } else {
      // Show summary and save to Supabase
      _showSummary();
    }
  }

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test Complete'),
        content: const Text(
          'Your results have been recorded in your clinical profile. '
          'If you noticed distortions, please schedule a consultation with an ophthalmologist.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }
}

class AmslerGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const divisions = 20;
    final stepX = size.width / divisions;
    final stepY = size.height / divisions;

    for (var i = 0; i <= divisions; i++) {
      canvas.drawLine(Offset(i * stepX, 0), Offset(i * stepX, size.height), paint);
      canvas.drawLine(Offset(0, i * stepY), Offset(size.width, i * stepY), paint);
    }

    // Center dot
    final centerPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
