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
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

class AstigmatismTestScreen extends StatefulWidget {
  const AstigmatismTestScreen({super.key});

  @override
  State<AstigmatismTestScreen> createState() => _AstigmatismTestScreenState();
}

class _AstigmatismTestScreenState extends State<AstigmatismTestScreen> {
  int? _selectedAngle;

  void _finishTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Test Complete'),
        content: Text(_selectedAngle == null
            ? 'No astigmatism detected.'
            : 'Possible astigmatism detected near axis $_selectedAngle°. Please consult an ophthalmologist.'),
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
      appBar: AppBar(title: const Text('Astigmatism Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '1. Cover one eye.\n2. Look at the center of the wheel.\n3. Do any lines appear thicker, darker, or more distinct than others? If so, tap that line.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AdaptiveCard(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Draw radiating lines
                      for (int i = 0; i < 12; i++)
                        Transform.rotate(
                          angle: i * pi / 12,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAngle = i * 15;
                              });
                            },
                            child: Container(
                              width: 280,
                              height: _selectedAngle == i * 15 ? 6 : 2, // Thicker if selected
                              color: _selectedAngle == i * 15 ? AppColors.error : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      // Center cover
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _finishTest,
                child: const Text('Submit / All lines look the same'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
