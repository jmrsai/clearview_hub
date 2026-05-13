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

class AmblyopiaTherapyGame extends StatefulWidget {
  const AmblyopiaTherapyGame({super.key});

  @override
  State<AmblyopiaTherapyGame> createState() => _AmblyopiaTherapyGameState();
}

class _AmblyopiaTherapyGameState extends State<AmblyopiaTherapyGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  
  double _targetX = 150.0;
  double _targetY = 300.0;
  int _score = 0;
  int _level = 1;
  double _targetSize = 60.0;
  double _speedMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _moveTarget() {
    setState(() {
      _targetX = _random.nextDouble() * 250 + 20; // safe bounds
      _targetY = _random.nextDouble() * 500 + 100;
      _score++;

      // Level progression logic
      if (_score % 10 == 0 && _level < 3) {
        _level++;
        _targetSize = _targetSize * 0.7; // Shrink target
        _speedMultiplier = _speedMultiplier * 1.5; // Increase wobble speed
        _controller.duration = Duration(milliseconds: (2000 ~/ _speedMultiplier));
        _controller.repeat(reverse: true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Level Up! Now Level $_level. Target is smaller and faster!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Amblyopia Dichoptic Therapy')),
      body: Stack(
        children: [
          // Background instructions
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: AdaptiveCard(
              child: Column(
                children: [
                  const Text(
                    'Put on your Red/Cyan 3D glasses.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the moving target. The target is drawn in red, while the background noise is drawn in cyan. This forces both eyes to work together.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Level: $_level',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                      Text(
                        'Score: $_score',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Cyan background noise (Only seen by the eye with the Red lens)
          ...List.generate(20, (index) {
            return Positioned(
              left: _random.nextDouble() * 300,
              top: _random.nextDouble() * 600 + 150,
              child: const Icon(Icons.star, color: Colors.cyan, size: 24),
            );
          }),

          // Red Target (Only seen by the eye with the Cyan lens)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _targetX + sin(_controller.value * 2 * pi) * 20, // Add some wobble
                top: _targetY + cos(_controller.value * 2 * pi) * 20,
                child: GestureDetector(
                  onTap: _moveTarget,
                  child: Container(
                    width: _targetSize,
                    height: _targetSize,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.redAccent, blurRadius: 10, spreadRadius: 5)
                      ]
                    ),
                    child: Icon(Icons.ads_click, color: Colors.white, size: _targetSize * 0.5),
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
