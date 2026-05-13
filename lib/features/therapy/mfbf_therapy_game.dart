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

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/database/database_helper.dart';

class MfbfTherapyGame extends StatefulWidget {
  final String patientId;
  const MfbfTherapyGame({super.key, required this.patientId});

  @override
  State<MfbfTherapyGame> createState() => _MfbfTherapyGameState();
}

class _MfbfTherapyGameState extends State<MfbfTherapyGame> {
  bool _isRunning = false;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  
  final Random _random = Random();
  String _targetLetter = 'E';
  final List<Map<String, dynamic>> _letters = [];
  
  final Color _redLensColor = const Color(0xFFFF0000); // Seen only by cyan lens eye
  final Color _cyanLensColor = const Color(0xFF00FFFF); // Seen only by red lens eye
  
  void _start() {
    setState(() {
      _isRunning = true;
      _score = 0;
      _timeLeft = 30;
    });
    _generateGrid();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _stop();
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    
    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'mfbf_red_cyan',
      'duration_seconds': 30,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Score: $_score',
    });
  }

  void _generateGrid() {
    _letters.clear();
    List<String> alphabet = 'ABCDEFGHJKLMNOPQRSTUVWXYZ'.split('');
    _targetLetter = alphabet[_random.nextInt(alphabet.length)];
    
    // Add target
    _letters.add({'char': _targetLetter, 'isTarget': true, 'color': _redLensColor});
    
    // Add distractors
    for (int i = 0; i < 24; i++) {
      String char;
      do {
        char = alphabet[_random.nextInt(alphabet.length)];
      } while (char == _targetLetter);
      
      // Mix colors so both eyes have to work
      Color color = _random.nextBool() ? _redLensColor : _cyanLensColor;
      _letters.add({'char': char, 'isTarget': false, 'color': color});
    }
    
    _letters.shuffle();
  }

  void _onTapLetter(bool isTarget) {
    if (!_isRunning) return;
    setState(() {
      if (isTarget) {
        _score += 10;
        _generateGrid(); // Generate a new grid upon finding the target
      } else {
        _score = max(0, _score - 5);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background is crucial for anaglyph MFBF
      appBar: AppBar(
        title: const Text('MFBF Therapy', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_isRunning) ...[
                const Spacer(),
                const Icon(Icons.remove_red_eye_outlined, size: 80, color: Colors.black54),
                const SizedBox(height: 24),
                Text('Dichoptic Training', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black)),
                const SizedBox(height: 16),
                const Text(
                  'Put on your Red-Cyan Anaglyph glasses.\nFind and tap the target letter as fast as you can. Both of your eyes will need to work together to win!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, foregroundColor: Colors.white),
                  onPressed: _start,
                  child: const Text('Start Game'),
                ),
                const Spacer(),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time: $_timeLeft', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('Score: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Find the letter:', style: const TextStyle(fontSize: 16, color: Colors.black54)),
                Text(_targetLetter, style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: _cyanLensColor)),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: _letters.length,
                    itemBuilder: (context, index) {
                      final item = _letters[index];
                      return GestureDetector(
                        onTap: () => _onTapLetter(item['isTarget']),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item['char'],
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: item['color'],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: _stop, 
                  child: const Text('End Session', style: TextStyle(color: Colors.red))
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
