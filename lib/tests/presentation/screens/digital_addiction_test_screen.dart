import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../sensors/domain/sensor_orchestrator.dart';

class DigitalAddictionTestScreen extends StatefulWidget {
  const DigitalAddictionTestScreen({super.key});

  @override
  State<DigitalAddictionTestScreen> createState() => _DigitalAddictionTestScreenState();
}

class _DigitalAddictionTestScreenState extends State<DigitalAddictionTestScreen> {
  int _currentQuestionIndex = 0;
  final List<int> _answers = [];
  
  final List<String> _questions = [
    "Do you check your phone immediately upon waking up?",
    "Do you feel anxious when you don't have your phone?",
    "Do you often use your phone while walking or talking to others?",
    "Do you lose track of time while scrolling social media?",
    "Do you use your phone in bed before trying to sleep?"
  ];

  void _answerQuestion(int score) {
    setState(() {
      _answers.add(score);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    int totalScore = _answers.fold(0, (sum, item) => sum + item);
    final context = SensorOrchestrator().currentContext;
    
    // Abstract multiplier based on current real-time data
    if (context.batteryLevel < 15 && context.ambientLightLux < 10) {
      // Dark room, low battery implies extreme binge session
      totalScore += 5;
    }

    String resultText = "Low Dependency";
    if (totalScore > 18) {
      resultText = "High Addiction Risk (Detox Required)";
    } else if (totalScore > 10) {
      resultText = "Moderate Dependency";
    }

    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Addiction Score', style: TextStyle(color: Colors.white)),
        content: Text('Your Score: $totalScore\n$resultText', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(this.context);
            },
            child: const Text('Complete', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Addiction Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[800],
              color: AppColors.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: const TextStyle(color: AppColors.primary, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              _questions[_currentQuestionIndex],
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _buildAnswerButton("Never (0)", 0),
            _buildAnswerButton("Rarely (1)", 1),
            _buildAnswerButton("Sometimes (2)", 2),
            _buildAnswerButton("Often (3)", 3),
            _buildAnswerButton("Always (4)", 4),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceElevated,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _answerQuestion(score),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
