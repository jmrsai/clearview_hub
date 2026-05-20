import 'dart:math';
import 'package:flutter/material.dart';

class VisualAcuityTestScreen extends StatefulWidget {
  const VisualAcuityTestScreen({super.key});

  @override
  State<VisualAcuityTestScreen> createState() => _VisualAcuityTestScreenState();
}

class _VisualAcuityTestScreenState extends State<VisualAcuityTestScreen> {
  int _currentDirection = 0; // 0: Right, 1: Down, 2: Left, 3: Up
  double _currentFontSize = 140.0;
  int _correctAnswers = 0;
  int _totalAttempts = 0;
  final int _maxAttempts = 10;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateNextE();
  }

  void _generateNextE() {
    setState(() {
      _currentDirection = _random.nextInt(4);
    });
  }

  void _handleAnswer(int selectedDirection) {
    setState(() {
      _totalAttempts++;
      if (selectedDirection == _currentDirection) {
        _correctAnswers++;
        _currentFontSize = _currentFontSize * 0.85; // Shrink letter on success
      }
      
      if (_totalAttempts >= _maxAttempts) {
        _showResultsDialog();
      } else {
        _generateNextE();
      }
    });
  }

  void _showResultsDialog() {
    double acuityScore = (_correctAnswers / _maxAttempts) * 100;
    String acuityText = '20/20';
    if (acuityScore < 50) acuityText = '20/200';
    else if (acuityScore < 80) acuityText = '20/40';
    else if (acuityScore < 100) acuityText = '20/25';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF151B2B),
        title: const Text('Test Complete', style: TextStyle(color: Colors.white)),
        content: Text(
          'Your estimated visual acuity is $acuityText.\n\nScore: $_correctAnswers/$_maxAttempts',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to dashboard
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
        title: const Text('Visual Acuity Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Tumbling E Test: Cover one eye and tap the arrow showing which way the "E" is pointing.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 60),
            // The Tumbling E
            SizedBox(
              height: 200,
              child: Center(
                child: Transform.rotate(
                  angle: _currentDirection * (pi / 2),
                  child: Text(
                    'E',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _currentFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Directional Pad
            _buildDirectionPad(),
            const SizedBox(height: 40),
            Text(
              'Progress: $_totalAttempts / $_maxAttempts',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionPad() {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: _dirButton(Icons.keyboard_arrow_up, 3), // Up
          ),
          Positioned(
            bottom: 0,
            child: _dirButton(Icons.keyboard_arrow_down, 1), // Down
          ),
          Positioned(
            left: 0,
            child: _dirButton(Icons.keyboard_arrow_left, 2), // Left
          ),
          Positioned(
            right: 0,
            child: _dirButton(Icons.keyboard_arrow_right, 0), // Right
          ),
          // Center decorative element
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00E5FF).withOpacity(0.1),
            ),
            child: const Icon(Icons.remove_red_eye, color: Color(0xFF00E5FF), size: 20),
          )
        ],
      ),
    );
  }

  Widget _dirButton(IconData icon, int direction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ]
      ),
      child: IconButton(
        iconSize: 48,
        color: const Color(0xFF00E5FF),
        icon: Icon(icon),
        onPressed: () => _handleAnswer(direction),
      ),
    );
  }
}
