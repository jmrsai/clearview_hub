import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../widgets/glass_card.dart';

class FocusProGame extends StatefulWidget {
  const FocusProGame({super.key});

  @override
  State<FocusProGame> createState() => _FocusProGameState();
}

class _FocusProGameState extends State<FocusProGame> {
  int _score = 0;
  int _timeLeft = 30;
  bool _isPlaying = false;
  bool _isFinished = false;
  Timer? _timer;

  Offset _targetPos = const Offset(100, 100);
  final Random _random = Random();

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _isPlaying = true;
      _isFinished = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _stopGame();
      }
    });

    _moveTarget();
  }

  void _moveTarget() {
    if (!_isPlaying) return;

    final size = MediaQuery.of(context).size;
    setState(() {
      _targetPos = Offset(
        _random.nextDouble() * (size.width - 100) + 50,
        _random.nextDouble() * (size.height - 300) + 150,
      );
    });
  }

  void _onTargetTap() {
    if (!_isPlaying) return;
    setState(() {
      _score++;
    });
    _moveTarget();
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isFinished = true;
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => Navigator.pop(context),
                        ),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: Text(
                            'Score: $_score  |  Time: $_timeLeft',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (_isPlaying)
              Positioned(
                left: _targetPos.dx - 40,
                top: _targetPos.dy - 40,
                child: GestureDetector(
                  onTap: _onTargetTap,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: const RadialGradient(
                          colors: [Colors.white, Colors.cyan],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.center_focus_strong,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (!_isPlaying && !_isFinished)
              _buildCenterOverlay(_buildStartUI()),
            if (_isFinished) _buildCenterOverlay(_buildResultUI()),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterOverlay(Widget child) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GlassCard(padding: const EdgeInsets.all(32), child: child),
      ),
    );
  }

  Widget _buildStartUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.center_focus_strong, color: Colors.cyan, size: 64),
        const SizedBox(height: 16),
        const Text(
          'FOCUS PRO',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap the targets as they appear. Train your eyes to track and focus quickly!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startGame,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          ),
          child: const Text('START TRAINING'),
        ),
      ],
    );
  }

  Widget _buildResultUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'SESSION COMPLETE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Targets Hit: $_score',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Score: ${_score * 10} XP',
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'EXIT',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ],
    );
  }
}
