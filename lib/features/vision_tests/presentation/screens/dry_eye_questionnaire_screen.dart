import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class DryEyeQuestionnaireScreen extends StatefulWidget {
  const DryEyeQuestionnaireScreen({super.key});

  @override
  State<DryEyeQuestionnaireScreen> createState() => _DryEyeQuestionnaireScreenState();
}

class _DryEyeQuestionnaireScreenState extends State<DryEyeQuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  int _totalScore = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Have you experienced eyes that are sensitive to light?',
      'options': ['None of the time', 'Some of the time', 'Half of the time', 'Most of the time', 'All of the time'],
      'scores': [0, 1, 2, 3, 4]
    },
    {
      'question': 'Have you experienced eyes that feel gritty?',
      'options': ['None of the time', 'Some of the time', 'Half of the time', 'Most of the time', 'All of the time'],
      'scores': [0, 1, 2, 3, 4]
    },
    {
      'question': 'Have you experienced painful or sore eyes?',
      'options': ['None of the time', 'Some of the time', 'Half of the time', 'Most of the time', 'All of the time'],
      'scores': [0, 1, 2, 3, 4]
    },
    {
      'question': 'Have you experienced blurred vision?',
      'options': ['None of the time', 'Some of the time', 'Half of the time', 'Most of the time', 'All of the time'],
      'scores': [0, 1, 2, 3, 4]
    },
    {
      'question': 'Have you experienced poor vision?',
      'options': ['None of the time', 'Some of the time', 'Half of the time', 'Most of the time', 'All of the time'],
      'scores': [0, 1, 2, 3, 4]
    },
  ];

  bool _isFinished = false;

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _isFinished = true;
      }
    });
  }

  void _reset() {
    setState(() {
      _currentQuestionIndex = 0;
      _totalScore = 0;
      _isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Dry Eye Assessment (OSDI)'),
        backgroundColor: Colors.transparent,
      ),
      body: _isFinished ? _buildResult() : _buildQuestionnaire(),
    );
  }

  Widget _buildQuestionnaire() {
    final question = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 32),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            question['question'],
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          ...List.generate(
            question['options'].length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _answerQuestion(question['scores'][index]),
                child: Text(question['options'][index], style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    // Basic OSDI formula mapping for a 5 question subset:
    // score range 0 - 20
    String severity;
    Color color;
    String recommendation;

    if (_totalScore <= 4) {
      severity = 'Normal';
      color = Colors.green;
      recommendation = 'Your eyes seem healthy. Keep up the good habits!';
    } else if (_totalScore <= 9) {
      severity = 'Mild Dry Eye';
      color = Colors.yellow;
      recommendation = 'You may benefit from over-the-counter lubricating eye drops and screen breaks.';
    } else if (_totalScore <= 14) {
      severity = 'Moderate Dry Eye';
      color = Colors.orange;
      recommendation = 'Consider using artificial tears regularly and improving your environment (humidifier).';
    } else {
      severity = 'Severe Dry Eye';
      color = Colors.red;
      recommendation = 'Please consult an eye care professional for a comprehensive dry eye evaluation.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.opacity, size: 80, color: color),
            const SizedBox(height: 24),
            Text(
              severity,
              style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_totalScore / 20',
              style: const TextStyle(color: Colors.white54, fontSize: 18),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                recommendation,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: _reset,
              child: const Text('Retake Assessment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
