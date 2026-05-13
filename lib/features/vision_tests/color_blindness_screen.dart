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
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/vision_test_result.dart';
import '../../core/database/database_helper.dart';
import '../alerts/proximity_alert_service.dart';
import '../../core/services/gemini_service.dart';

/// Ishihara-style color blindness test using programmatic circle packing.
class ColorBlindnessScreen extends StatefulWidget {
  final String patientId;
  const ColorBlindnessScreen({super.key, required this.patientId});
  @override
  State<ColorBlindnessScreen> createState() => _ColorBlindnessScreenState();
}

// Each plate: number visible to normal vision, answer, fg/bg colors
const _plates = [
  (number: '12', protan: false, fg: Color(0xFFE74C3C), bg: Color(0xFF2ECC71)),
  (number: '8',  protan: true,  fg: Color(0xFFF39C12), bg: Color(0xFF27AE60)),
  (number: '6',  protan: false, fg: Color(0xFFE67E22), bg: Color(0xFF1ABC9C)),
  (number: '29', protan: true,  fg: Color(0xFFE91E63), bg: Color(0xFF4CAF50)),
  (number: '57', protan: false, fg: Color(0xFFFF5722), bg: Color(0xFF8BC34A)),
  (number: '5',  protan: true,  fg: Color(0xFFFF9800), bg: Color(0xFF4DB6AC)),
  (number: '3',  protan: false, fg: Color(0xFFF44336), bg: Color(0xFF66BB6A)),
  (number: '15', protan: true,  fg: Color(0xFFFF7043), bg: Color(0xFF26A69A)),
];

class _ColorBlindnessScreenState extends State<ColorBlindnessScreen> {
  int _plateIndex = 0;
  int _correct = 0;
  final _ctrl = TextEditingController();
  bool _showResult = false;
  bool _isGazePaused = false;
  List<_Circle>? _bgCircles;
  List<_Circle>? _fgCircles;

  @override
  void initState() {
    super.initState();
    ProximityAlertService.instance.addListener(_onProximityStatusChange);
  }

  @override
  void dispose() {
    ProximityAlertService.instance.removeListener(_onProximityStatusChange);
    _ctrl.dispose();
    super.dispose();
  }

  void _onProximityStatusChange(ProximityStatus status) {
    if (mounted) {
      setState(() {
        _isGazePaused = !status.isLookingAtScreen;
      });
    }
  }

  void _generateCircles(Size size, String number, Color fg, Color bg) {
    final rng = Random(number.hashCode + size.width.toInt());
    _bgCircles = [];
    _fgCircles = [];

    // Generate background dots
    for (int i = 0; i < 800; i++) {
      final r = rng.nextDouble() * 6 + 3;
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      // Jitter background color slightly for realism
      final color = Color.lerp(bg, Colors.brown, rng.nextDouble() * 0.2)!
          .withValues(alpha: 0.6 + rng.nextDouble() * 0.4);
      _bgCircles!.add(_Circle(x: x, y: y, r: r, color: color));
    }

    // Generate foreground dots (will be masked by text in painter)
    for (int i = 0; i < 600; i++) {
      final r = rng.nextDouble() * 7 + 4;
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      // Jitter foreground color
      final color = Color.lerp(fg, Colors.orange, rng.nextDouble() * 0.2)!
          .withValues(alpha: 0.8 + rng.nextDouble() * 0.2);
      _fgCircles!.add(_Circle(x: x, y: y, r: r, color: color));
    }
  }

  void _onSubmit() {
    final answer = _ctrl.text.trim();
    final plate = _plates[_plateIndex];
    if (answer == plate.number) _correct++;
    _ctrl.clear();
    setState(() {
      _bgCircles = null;
      _fgCircles = null;
      if (_plateIndex < _plates.length - 1) {
        _plateIndex++;
      } else {
        _showResult = true;
        _saveResult();
      }
    });
  }

  Future<void> _saveResult() async {
    await DatabaseHelper.instance.insertVisionTestResult(VisionTestResult(
      patientId: widget.patientId,
      testType: 'color_blindness',
      performedAt: DateTime.now(),
      correctAnswers: _correct,
      totalQuestions: _plates.length,
      notes: _getInterpretation(),
    ));
  }

  String _getInterpretation() {
    final score = _correct / _plates.length;
    if (score >= 0.875) return 'Normal color vision';
    if (score >= 0.5) return 'Mild color vision deficiency';
    return 'Significant color vision deficiency';
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Color Vision Test')),
      body: Stack(
        children: [
          _showResult ? _resultView() : _testView(context),
          if (_isGazePaused && !_showResult)
            _buildGazePauseOverlay(),
        ],
      ),
    );
  }

  Widget _buildGazePauseOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility_off, color: AppColors.error, size: 80),
            const SizedBox(height: 24),
            Text('TEST PAUSED', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.error)),
            const SizedBox(height: 16),
            const Text(
              'Please look directly at the screen\nto resume the test.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testView(BuildContext ctx) {
    final plate = _plates[_plateIndex];
    return SafeArea(child: Column(children: [
      const SizedBox(height: 12),
      Text('Plate ${_plateIndex + 1} of ${_plates.length}',
          style: Theme.of(ctx).textTheme.bodyMedium),
      LinearProgressIndicator(value: _plateIndex / _plates.length,
          backgroundColor: AppColors.glassFill, color: AppColors.cyan,
          borderRadius: BorderRadius.circular(4)),
      const SizedBox(height: 12),
      Text('What number do you see?',
          style: Theme.of(ctx).textTheme.titleMedium, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Expanded(child: Center(child: AspectRatio(aspectRatio: 1,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipOval(child: LayoutBuilder(builder: (ctx, c) {
            final size = Size(c.maxWidth, c.maxHeight);
            if (_bgCircles == null) {
              _generateCircles(size, plate.number, plate.fg, plate.bg);
            }
            return CustomPaint(
              painter: _IshiharaPainter(
                bgCircles: _bgCircles!,
                fgCircles: _fgCircles!,
                number: plate.number,
              ),
              size: size,
            );
          })),
        ),
      ))),
      const SizedBox(height: 16),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Row(children: [
        Expanded(child: TextField(
          controller: _ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter number...'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        )),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _onSubmit();
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size(80, 52)),
          child: const Text('Next'),
        ),
      ])),
      const SizedBox(height: 16),
      TextButton(onPressed: () { 
          HapticFeedback.lightImpact();
          _ctrl.text = ''; 
          _onSubmit(); 
        },
          child: const Text("Can't see a number")),
      const SizedBox(height: 16),
    ]));
  }

  Widget _resultView() {
    final score = _correct / _plates.length;
    final isNormal = score >= 0.875;
    return SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(isNormal ? Icons.palette : Icons.warning_amber_rounded,
          size: 72, color: isNormal ? AppColors.success : AppColors.warning),
      const SizedBox(height: 20),
      Text('Color Vision Result', style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 20),
      AdaptiveCard(child: Column(children: [
        Text('$_correct / ${_plates.length} correct',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900,
                color: AppColors.cyan)),
        const SizedBox(height: 8),
        Text(_getInterpretation(), style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        TextButton.icon(
          icon: const Icon(Icons.auto_awesome, size: 16, color: AppColors.cyan),
          label: const Text('AI Analysis'),
          onPressed: _showAiInterpretation,
        ),
      ])),
      const SizedBox(height: 24),
      ElevatedButton.icon(icon: const Icon(Icons.arrow_back),
          label: const Text('Return'), onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          }),
    ])));
  }

  Future<void> _showAiInterpretation() async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
    );

    final prompt = '''
Patient just completed an Ishihara color blindness test with score $_correct/${_plates.length}.
Interpret this result medically. 
Explain what this means for daily life (e.g., reading maps, driving, certain professions).
Recommend whether they should see a specialist.
Keep it supportive and clinical.
''';
    
    final response = await GeminiService.instance.sendMessage(prompt);
    
    if (mounted) {
      Navigator.pop(context); // Close loading
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Row(children: [
            const Icon(Icons.auto_awesome, color: AppColors.cyan),
            const SizedBox(width: 8),
            const Text('AI Clinical Insight'),
          ]),
          content: SingleChildScrollView(child: Text(response)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Dismiss')),
          ],
        ),
      );
    }
  }
}

class _Circle { final double x, y, r; final Color color; const _Circle({required this.x, required this.y, required this.r, required this.color}); }

class _IshiharaPainter extends CustomPainter {
  final List<_Circle> bgCircles;
  final List<_Circle> fgCircles;
  final String number;

  const _IshiharaPainter({
    required this.bgCircles,
    required this.fgCircles,
    required this.number,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Background dots
    final paint = Paint()..style = PaintingStyle.fill;
    for (final c in bgCircles) {
      paint.color = c.color;
      canvas.drawCircle(Offset(c.x, c.y), c.r, paint);
    }

    // 2. Draw Foreground dots with text mask
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // Draw all foreground dots
    for (final c in fgCircles) {
      paint.color = c.color;
      canvas.drawCircle(Offset(c.x, c.y), c.r, paint);
    }

    // Use TextPainter to create the mask using BlendMode.dstIn
    final textPainter = TextPainter(
      text: TextSpan(
        text: number,
        style: TextStyle(
          fontSize: size.width * 0.65,
          fontWeight: FontWeight.w900,
          color: Colors.black, // Color doesn't matter, just the shape
          foreground: Paint()..blendMode = BlendMode.dstIn,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_IshiharaPainter old) =>
      old.bgCircles != bgCircles || old.fgCircles != fgCircles;
}
