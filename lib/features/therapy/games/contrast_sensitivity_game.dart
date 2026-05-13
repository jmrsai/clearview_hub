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
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ContrastSensitivityGame extends StatefulWidget {
  const ContrastSensitivityGame({super.key});

  @override
  State<ContrastSensitivityGame> createState() => _ContrastSensitivityGameState();
}

class _ContrastSensitivityGameState extends State<ContrastSensitivityGame> {
  int _score = 0;
  double _contrast = 1.0;
  late int _targetIndex;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _nextLevel();
  }

  void _nextLevel() {
    setState(() {
      _targetIndex = _random.nextInt(4);
      _contrast = max(0.01, _contrast * 0.85); // Decrease contrast
    });
  }

  void _handleTap(int index) {
    if (index == _targetIndex) {
      setState(() {
        _score++;
      });
      _nextLevel();
    } else {
      _gameOver();
    }
  }

  void _gameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2235),
        title: const Text('Test Complete', style: TextStyle(color: Colors.white)),
        content: Text(
          'Your final contrast score: $_score\n'
          'Min contrast reached: ${(_contrast * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('FINISH'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _contrast = 1.0;
              });
              _nextLevel();
            },
            child: const Text('RETRY'),
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
        title: const Text('Contrast Sensitivity'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Tap the circle that is SLIGHTLY different.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $_score',
              style: const TextStyle(color: AppColors.cyan, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final isTarget = index == _targetIndex;
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                        255, 
                        255, 
                        255, 
                        isTarget ? _contrast : 1.0,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
