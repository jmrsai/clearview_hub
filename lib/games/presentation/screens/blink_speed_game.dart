import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../core/theme/app_colors.dart';

class BlinkSpeedGameScreen extends StatefulWidget {
  const BlinkSpeedGameScreen({super.key});

  @override
  State<BlinkSpeedGameScreen> createState() => _BlinkSpeedGameScreenState();
}

class _BlinkSpeedGameScreenState extends State<BlinkSpeedGameScreen> {
  int _score = 0;
  bool _isPlaying = false;
  int _timeLeft = 30;
  Timer? _gameTimer;
  Timer? _targetTimer;

  // The 'eye' target on screen
  double _targetX = 0;
  double _targetY = 0;
  bool _showTarget = false;

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _isPlaying = true;
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });

    _spawnTarget();
  }

  void _spawnTarget() {
    if (!_isPlaying) return;
    
    final random = Random();
    setState(() {
      _showTarget = false;
    });

    _targetTimer = Timer(Duration(milliseconds: 500 + random.nextInt(1500)), () {
      if (!mounted || !_isPlaying) return;
      setState(() {
        _targetX = random.nextDouble() * 0.8 + 0.1; // 10% to 90%
        _targetY = random.nextDouble() * 0.7 + 0.15;
        _showTarget = true;
      });
      
      // Auto hide if not clicked fast enough
      Timer(const Duration(milliseconds: 1000), () {
         if (mounted && _showTarget) {
            _spawnTarget();
         }
      });
    });
  }

  void _onTargetTap() {
    if (!_showTarget) return;
    setState(() {
      _score += 10;
      _showTarget = false;
    });
    // Visual or haptic feedback for blink action
    _spawnTarget();
  }

  void _endGame() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _showTarget = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Game Over!', style: TextStyle(color: Colors.white)),
        content: Text('Your Score: $_score\n\nGreat job maintaining your blink reflex!', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startGame();
            },
            child: const Text('Play Again', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _targetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blink Reflex Game'),
      ),
      body: Stack(
        children: [
          // Score & Time HUD
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $_score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('Time: ${_timeLeft}s', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          
          if (!_isPlaying && _timeLeft == 30)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                onPressed: _startGame,
                child: const Text('Start Game', style: TextStyle(fontSize: 24, color: Colors.black)),
              ),
            ),

          if (_showTarget)
            Align(
              alignment: FractionalOffset(_targetX, _targetY),
              child: GestureDetector(
                onTap: _onTargetTap,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove_red_eye, color: Colors.black, size: 36),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
