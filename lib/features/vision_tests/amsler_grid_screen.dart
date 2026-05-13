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

class AmslerGridScreen extends StatefulWidget {
  final String patientId;
  const AmslerGridScreen({super.key, required this.patientId});

  @override
  State<AmslerGridScreen> createState() => _AmslerGridScreenState();
}

class _AmslerGridScreenState extends State<AmslerGridScreen> {
  final Set<int> _selectedCells = {};
  static const int gridSize = 20;

  void _toggleCell(int index) {
    setState(() {
      if (_selectedCells.contains(index)) {
        _selectedCells.remove(index);
      } else {
        _selectedCells.add(index);
      }
    });
  }

  void _finishTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Test Complete'),
        content: Text(_selectedCells.isEmpty
            ? 'No distortion reported. Macula appears healthy.'
            : 'Distortion reported in ${_selectedCells.length} areas. Please consult an ophthalmologist.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Amsler Grid (Macular Test)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '1. Cover one eye.\n2. Stare at the center dot.\n3. Tap any areas where lines appear wavy, blurred, or missing.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AdaptiveCard(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.white, // Grid is always white with black lines
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      // Grid
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _toggleCell(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.5),
                                color: _selectedCells.contains(index)
                                    ? Colors.red.withValues(alpha: 0.5)
                                    : Colors.transparent,
                              ),
                            ),
                          );
                        },
                      ),
                      // Center Dot
                      Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _finishTest,
                child: const Text('Submit Results'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
