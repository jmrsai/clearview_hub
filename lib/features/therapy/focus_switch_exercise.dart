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
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';

class FocusSwitchExercise extends StatefulWidget {
  final String patientId;
  const FocusSwitchExercise({super.key, required this.patientId});

  @override
  State<FocusSwitchExercise> createState() => _FocusSwitchExerciseState();
}

class _FocusSwitchExerciseState extends State<FocusSwitchExercise> {
  bool _isNearFocus = true;
  bool _isRunning = false;
  Timer? _timer;
  int _score = 0;
  String _currentLetter = 'E';
  String _targetSymbol = '?';
  final List<String> _letters = ['E', 'H', 'N', 'Z', 'V', 'K', 'R'];
  final List<String> _symbols = ['★', '◆', '●', '▲', '■'];

  void _start() {
    setState(() {
      _isRunning = true;
      _score = 0;
      _isNearFocus = true;
      _nextRound();
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _isNearFocus = !_isNearFocus;
        if (_isNearFocus) _nextRound();
      });
    });
  }

  void _nextRound() {
    _currentLetter = _letters[math.Random().nextInt(_letters.length)];
    _targetSymbol = _symbols[math.Random().nextInt(_symbols.length)];
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _isRunning = false);

    DatabaseHelper.instance.insertEyeExerciseSession({
      'patient_id': widget.patientId,
      'exercise_type': 'focus_switch',
      'duration_seconds': 0,
      'performed_at': DateTime.now().toIso8601String(),
      'notes': 'Final Score: $_score',
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Focus Switch')),
      body: SafeArea(
        child: _isRunning ? _gameView() : _setupView(),
      ),
    );
  }

  Widget _setupView() {
    return Center(
      child: AdaptiveCard(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.center_focus_strong, size: 64, color: AppColors.violet),
            const SizedBox(height: 16),
            Text('Focus Training', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 12),
            const Text(
              'Switch your focus between the center letter (Near) and the faint background symbol (Far) every 5 seconds.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _start();
              },
              child: const Text('Start Training'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameView() {
    return Stack(
      children: [
        // Far Focus Layer
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isNearFocus ? 0.05 : 0.4,
          child: Center(
            child: Text(
              _targetSymbol,
              style: const TextStyle(fontSize: 300, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Near Focus Layer
        if (_isNearFocus)
          Center(
            child: AdaptiveCard(
              padding: const EdgeInsets.all(20),
              child: Text(
                _currentLetter,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.cyan),
              ),
            ),
          ),

        // UI Controls
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                Chip(
                  label: Text(_isNearFocus ? 'FOCUS NEAR' : 'FOCUS FAR',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                  backgroundColor: _isNearFocus ? AppColors.cyanDim : AppColors.violetDim,
                ),
                const SizedBox(height: 8),
                Text('Score: $_score', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Column(
            children: [
              if (!_isNearFocus) ...[
                const Text('Identify the symbol:', style: TextStyle(color: AppColors.textHint)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _symbols.map((s) => _symbolBtn(s)).toList(),
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _stop();
                },
                child: const Text('Stop Training', 
                  style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _symbolBtn(String s) {
    return AdaptiveCard(
      onTap: () {
        if (s == _targetSymbol) {
          setState(() => _score += 10);
          _nextRound(); // Immediately switch for engagement
          setState(() => _isNearFocus = true);
        }
      },
      padding: const EdgeInsets.all(12),
      child: Text(s, style: const TextStyle(fontSize: 24)),
    );
  }
}
