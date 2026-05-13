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
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

class SnellenChartScreen extends StatefulWidget {
  final String patientId;
  const SnellenChartScreen({super.key, required this.patientId});

  @override
  State<SnellenChartScreen> createState() => _SnellenChartScreenState();
}

class _SnellenChartScreenState extends State<SnellenChartScreen> {
  int _currentLine = 0;
  
  // Standard Snellen ratios (20/200 down to 20/20)
  final List<Map<String, dynamic>> _chartLines = [
    {'ratio': '20/200', 'letters': 'E', 'size': 120.0},
    {'ratio': '20/100', 'letters': 'F P', 'size': 80.0},
    {'ratio': '20/70', 'letters': 'T O Z', 'size': 60.0},
    {'ratio': '20/50', 'letters': 'L P E D', 'size': 40.0},
    {'ratio': '20/40', 'letters': 'P E C F D', 'size': 30.0},
    {'ratio': '20/30', 'letters': 'E D F C Z P', 'size': 24.0},
    {'ratio': '20/20', 'letters': 'F E L O P Z D', 'size': 16.0},
  ];

  void _nextTest() {
    if (_currentLine < _chartLines.length - 1) {
      setState(() {
        _currentLine++;
      });
    } else {
      // Test complete
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Test Complete'),
        content: Text('Visual Acuity Estimate: ${_chartLines[_currentLine]['ratio']}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close screen
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _chartLines[_currentLine];
    
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Visual Acuity (Snellen)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(
                  'Stand exactly 40cm away.\nCover one eye and read the letters.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              AdaptiveCard(
                child: Column(
                  children: [
                    Text(
                      currentData['ratio'],
                      style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      currentData['letters'],
                      style: TextStyle(
                        fontFamily: 'serif', // Snellen typically uses serif
                        fontSize: currentData['size'],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text('Cannot Read'),
                    onPressed: _showResults,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Can Read'),
                    onPressed: _nextTest,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
