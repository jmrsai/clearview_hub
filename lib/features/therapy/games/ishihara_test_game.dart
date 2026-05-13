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
import '../../../core/theme/app_colors.dart';

class IshiharaTestGame extends StatefulWidget {
  const IshiharaTestGame({super.key});

  @override
  State<IshiharaTestGame> createState() => _IshiharaTestGameState();
}

class _IshiharaTestGameState extends State<IshiharaTestGame> {
  int _currentIndex = 0;
  int _correctAnswers = 0;

  final List<Map<String, dynamic>> _plates = [
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/e/e0/Ishihara_9.png',
      'correct': '74',
      'options': ['74', '21', 'None', '71']
    },
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/b/b1/Ishihara_1.png',
      'correct': '12',
      'options': ['12', '15', 'None', '2']
    },
    {
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/a/a7/Ishihara_2.png',
      'correct': '8',
      'options': ['3', '8', 'None', '6']
    },
  ];

  void _handleAnswer(String answer) {
    if (answer == _plates[_currentIndex]['correct']) {
      _correctAnswers++;
    }

    if (_currentIndex < _plates.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2235),
        title: const Text('Test Complete', style: TextStyle(color: Colors.white)),
        content: Text(
          'Results: $_correctAnswers / ${_plates.length} correct.\n\n'
          '${_correctAnswers == _plates.length ? "Excellent color vision!" : "We recommend a professional eye exam."}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plate = _plates[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Ishihara Color Test'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'What number do you see in the circle?',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cyan, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.cyan.withValues(alpha: 0.2), blurRadius: 20)
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  plate['imageUrl'],
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250, width: 250, color: Colors.white10,
                    child: const Icon(Icons.broken_image, color: Colors.white24, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: (plate['options'] as List<String>).map((opt) => ElevatedButton(
                onPressed: () => _handleAnswer(opt),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2235),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(opt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
            const Spacer(),
            Text(
              'Plate ${_currentIndex + 1} of ${_plates.length}',
              style: const TextStyle(color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}
