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
import 'package:flutter/services.dart';
import 'dart:math';
import '../../core/theme/app_colors.dart';

/// Pediatric Vision Hub — gamified eye care for children.
class PediatricHub extends StatelessWidget {
  const PediatricHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('👶 Kids Vision Zone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Age selector banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFF59E0B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const Text('🌈 Eye Health for Children', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Fun, interactive therapy designed for young eyes', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Choose Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 14),
          _ActivityCard(
            emoji: '🎯',
            title: 'Fixation Target Game',
            subtitle: 'Trains gaze stability — great for amblyopia therapy',
            ageRange: 'Ages 2–8',
            color: const Color(0xFF0EA5E9),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FixationTargetGame())),
          ),
          const SizedBox(height: 12),
          _ActivityCard(
            emoji: '🏴‍☠️',
            title: 'Pirate Patch Challenge',
            subtitle: 'Occlusion therapy — strengthen the weaker eye through fun',
            ageRange: 'Ages 4–12',
            color: const Color(0xFF8B5CF6),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PatchTherapyScreen())),
          ),
          const SizedBox(height: 12),
          _ActivityCard(
            emoji: '🔭',
            title: 'Tracking Explorer',
            subtitle: 'Smooth pursuit training — follow the moving target',
            ageRange: 'Ages 3–10',
            color: const Color(0xFF10B981),
            onTap: () => _showComingSoon(context),
          ),
          const SizedBox(height: 12),
          _ActivityCard(
            emoji: '🔮',
            title: 'Color World',
            subtitle: 'Color vision assessment wrapped in a fun game',
            ageRange: 'Ages 5–14',
            color: const Color(0xFFEC4899),
            onTap: () => _showComingSoon(context),
          ),
          const SizedBox(height: 24),
          // Parent guide
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2235),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.violet.withAlpha(60)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.family_restroom, color: AppColors.violet),
                SizedBox(width: 10),
                Text('Parent Guide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ]),
              const SizedBox(height: 12),
              _GuideItem('👶 Newborns', 'Watch for eye misalignment, excessive tearing'),
              _GuideItem('🧒 Ages 1–3', '15–20 min of daily eye exercises'),
              _GuideItem('🧑 Ages 4–7', 'Annual eye exam, patch therapy if prescribed'),
              _GuideItem('🧑‍🎓 Ages 8+', 'Monitor for myopia progression, limit screen time'),
              const SizedBox(height: 12),
              Text('Always consult a pediatric ophthalmologist before starting therapy.',
                  style: TextStyle(color: AppColors.textHint, fontSize: 11)),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚀 Coming soon in the next update!')),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String ageRange;
  final Color color;
  final VoidCallback onTap;
  const _ActivityCard({required this.emoji, required this.title, required this.subtitle, required this.ageRange, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2235),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(8)),
              child: Text(ageRange, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ])),
          Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textHint),
        ]),
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final String age;
  final String tip;
  const _GuideItem(this.age, this.tip);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(age, style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w600, fontSize: 12)),
      const Text(' — ', style: TextStyle(color: AppColors.textHint)),
      Expanded(child: Text(tip, style: TextStyle(color: AppColors.textSecondary, fontSize: 12))),
    ]),
  );
}

/// Gamified fixation target game — animated ball to follow with gaze.
class FixationTargetGame extends StatefulWidget {
  const FixationTargetGame({super.key});
  @override
  State<FixationTargetGame> createState() => _FixationTargetGameState();
}

class _FixationTargetGameState extends State<FixationTargetGame> with TickerProviderStateMixin {
  late AnimationController _moveCtrl;
  late Animation<Offset> _position;
  int _taps = 0;
  bool _running = false;
  int _timeLeft = 60;
  late AnimationController _countdownCtrl;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  static const List<Color> _colors = [
    Color(0xFFEC4899), Color(0xFF0EA5E9), Color(0xFF10B981),
    Color(0xFFF59E0B), Color(0xFF8B5CF6), Color(0xFFEF4444),
  ];
  Color _currentColor = const Color(0xFFEC4899);

  @override
  void initState() {
    super.initState();
    _moveCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
      ..forward();
    _scale = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _countdownCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _randomizeTarget();
  }

  @override
  void dispose() {
    _moveCtrl.dispose(); _scaleCtrl.dispose(); _countdownCtrl.dispose(); super.dispose();
  }

  void _randomizeTarget() {
    final rng = Random();
    final endX = rng.nextDouble() * 0.6 + 0.2;
    final endY = rng.nextDouble() * 0.5 + 0.2;
    _position = Tween<Offset>(begin: Offset(endX, endY), end: Offset(endX, endY)).animate(_moveCtrl);
    _currentColor = _colors[rng.nextInt(_colors.length)];
    _moveCtrl.forward(from: 0);
    _scaleCtrl.forward(from: 0);
  }

  void _startGame() {
    setState(() { _running = true; _taps = 0; _timeLeft = 60; });
    _tick();
    _randomizeTarget();
  }

  void _tick() {
    if (!mounted || !_running) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        setState(() => _running = false);
        _showResult();
      } else {
        _tick();
      }
    });
  }

  void _onTap() {
    if (!_running) return;
    HapticFeedback.lightImpact();
    setState(() { _taps++; });
    _randomizeTarget();
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E2235),
        title: const Text('Game Over! 🎉', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Score: $_taps targets hit', style: const TextStyle(color: AppColors.cyan, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(_taps > 30 ? '⭐⭐⭐ Excellent tracking!' : _taps > 15 ? '⭐⭐ Good job!' : '⭐ Keep practicing!',
              style: const TextStyle(color: Colors.white70)),
        ]),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); _startGame(); }, child: const Text('Play Again')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(children: [
          const Text('🎯 Fixation Game', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (_running) ...[
            Text('⏱ $_timeLeft s', style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w700)),
            const SizedBox(width: 16),
            Text('✅ $_taps', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
          ],
        ]),
      ),
      body: GestureDetector(
        onTapDown: null,
        child: Stack(children: [
          Container(color: Colors.black),
          if (!_running)
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🎯', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text('Fixation Target Game', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text('Tap the moving target as fast as you can!\nGreat for training gaze stability.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text('Start Game', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ])),
          if (_running)
            AnimatedBuilder(
              animation: _position,
              builder: (_, _) => Positioned(
                left: _position.value.dx * size.width - 30,
                top: _position.value.dy * size.height - 30,
                child: GestureDetector(
                  onTap: _onTap,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: _currentColor,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _currentColor.withAlpha(150), blurRadius: 20, spreadRadius: 5)],
                      ),
                      child: const Icon(Icons.circle, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Patch therapy occlusion game for amblyopia.
class PatchTherapyScreen extends StatelessWidget {
  const PatchTherapyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('🏴‍☠️ Pirate Patch Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Text('🏴‍☠️', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text('Occlusion Therapy', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Patch your stronger eye and use activities to strengthen the weaker one.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
          const SizedBox(height: 28),
          _PatchStep(step: 1, title: 'Put on the eye patch', desc: 'Cover the stronger (dominant) eye as prescribed by your doctor.', emoji: '🏴‍☠️'),
          _PatchStep(step: 2, title: 'Set your timer', desc: 'Typically 2–6 hours daily. Follow your ophthalmologist\'s prescription.', emoji: '⏱️'),
          _PatchStep(step: 3, title: 'Do activities', desc: 'Read, draw, do puzzles, or play this app\'s vision games using only your weaker eye.', emoji: '🎨'),
          _PatchStep(step: 4, title: 'Track progress', desc: 'Daily tracking helps your doctor see improvement over weeks.', emoji: '📈'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withAlpha(60)),
            ),
            child: const Text(
              '⚠️ Only use patch therapy as prescribed by a certified pediatric ophthalmologist. Do not start patching without a professional diagnosis.',
              style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, minimumSize: const Size(double.infinity, 56)),
            icon: const Icon(Icons.timer, color: Colors.white),
            label: const Text('Start Patch Timer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ]),
      ),
    );
  }
}

class _PatchStep extends StatelessWidget {
  final int step;
  final String title;
  final String desc;
  final String emoji;
  const _PatchStep({required this.step, required this.title, required this.desc, required this.emoji});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
        child: Center(child: Text('$step', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$emoji  $title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        Text(desc, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
      ])),
    ]),
  );
}
