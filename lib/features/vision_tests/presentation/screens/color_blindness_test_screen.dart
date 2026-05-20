import 'dart:math';
import 'package:flutter/material.dart';

class ColorBlindnessTestScreen extends StatefulWidget {
  const ColorBlindnessTestScreen({super.key});

  @override
  State<ColorBlindnessTestScreen> createState() => _ColorBlindnessTestScreenState();
}

class _ColorBlindnessTestScreenState extends State<ColorBlindnessTestScreen> {
  int _currentPlate = 0;
  
  // A simple representation of plates: [Answer, Foreground color, Background color]
  final List<Map<String, dynamic>> _plates = [
    {
      'number': '12',
      'fg': Colors.orange,
      'bg': Colors.green,
    },
    {
      'number': '8',
      'fg': Colors.redAccent,
      'bg': Colors.teal,
    },
    {
      'number': '74',
      'fg': Colors.green,
      'bg': Colors.orangeAccent,
    },
  ];

  final TextEditingController _inputController = TextEditingController();

  void _submitAnswer() {
    FocusScope.of(context).unfocus();
    if (_currentPlate < _plates.length - 1) {
      setState(() {
        _currentPlate++;
        _inputController.clear();
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
          'Your color vision results have been logged.\nIf you struggled to see the numbers, you may have a form of color vision deficiency.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to dashboard
            },
            child: const Text('Done', style: TextStyle(color: Color(0xFF00E5FF))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Color Blindness Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Ishihara Plate Test',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Look at the plate below and enter the number you see.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              // Ishihara Plate Widget
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: CustomPaint(
                    painter: IshiharaPlatePainter(
                      number: _plates[_currentPlate]['number'],
                      fgColor: _plates[_currentPlate]['fg'],
                      bgColor: _plates[_currentPlate]['bg'],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter number',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 18),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _currentPlate < _plates.length - 1 ? 'Next Plate' : 'Finish Test',
                  style: const TextStyle(color: Color(0xFF0A0E1A), fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IshiharaPlatePainter extends CustomPainter {
  final String number;
  final Color fgColor;
  final Color bgColor;
  final Random random = Random();

  IshiharaPlatePainter({required this.number, required this.fgColor, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    double dotRadius = 4.0;
    double spacing = 10.0;

    // Draw the background dots
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Only draw inside the circle
        double dx = x - size.width / 2;
        double dy = y - size.height / 2;
        if (dx * dx + dy * dy <= (size.width / 2) * (size.height / 2)) {
          // Slight random offset
          double rx = x + (random.nextDouble() * 4 - 2);
          double ry = y + (random.nextDouble() * 4 - 2);
          double rr = dotRadius + random.nextDouble() * 3;

          bool isForeground = _isInText(rx, ry, size);
          
          Color baseColor = isForeground ? fgColor : bgColor;
          // Randomize shade slightly
          Color finalColor = baseColor.withOpacity(0.7 + random.nextDouble() * 0.3);

          canvas.drawCircle(Offset(rx, ry), rr, Paint()..color = finalColor);
        }
      }
    }
  }

  bool _isInText(double x, double y, Size size) {
    // A simplified heuristic to draw numbers based on zones.
    // For a real clinical app, you'd draw the text onto an offscreen canvas and read pixels.
    // This provides a visual simulation of the plates.
    
    // Normalize coordinates -1 to 1
    double nx = (x / size.width) * 2 - 1;
    double ny = (y / size.height) * 2 - 1;

    if (number == '12') {
      // Draw 1
      bool inOne = nx > -0.4 && nx < -0.2 && ny > -0.5 && ny < 0.5;
      // Draw 2
      bool inTwoTop = nx > 0.1 && nx < 0.5 && ny > -0.5 && ny < -0.3;
      bool inTwoDiag = nx > 0.1 && nx < 0.5 && ny > -0.3 && ny < 0.3 && (nx + ny) > 0.1 && (nx + ny) < 0.4;
      bool inTwoBottom = nx > 0.1 && nx < 0.5 && ny > 0.3 && ny < 0.5;
      return inOne || inTwoTop || inTwoDiag || inTwoBottom;
    } else if (number == '8') {
      bool inTopCircle = (nx * nx + (ny + 0.25) * (ny + 0.25)) < 0.08;
      bool inBottomCircle = (nx * nx + (ny - 0.25) * (ny - 0.25)) < 0.08;
      bool inTopHole = (nx * nx + (ny + 0.25) * (ny + 0.25)) < 0.02;
      bool inBottomHole = (nx * nx + (ny - 0.25) * (ny - 0.25)) < 0.02;
      return (inTopCircle && !inTopHole) || (inBottomCircle && !inBottomHole);
    } else if (number == '74') {
      // 7
      bool inSevenTop = nx > -0.5 && nx < -0.1 && ny > -0.5 && ny < -0.3;
      bool inSevenDiag = nx > -0.5 && nx < -0.1 && (nx + ny * 0.5) > -0.6 && (nx + ny * 0.5) < -0.4;
      // 4
      bool inFourLeft = nx > 0.1 && nx < 0.3 && ny > -0.5 && ny < 0.1;
      bool inFourMid = nx > 0.1 && nx < 0.6 && ny > 0.0 && ny < 0.2;
      bool inFourRight = nx > 0.4 && nx < 0.6 && ny > -0.3 && ny < 0.5;
      return inSevenTop || inSevenDiag || inFourLeft || inFourMid || inFourRight;
    }

    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
