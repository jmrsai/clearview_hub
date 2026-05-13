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
import 'dart:io';
import '../../core/services/retinal_ai_service.dart';
import '../../core/theme/app_colors.dart';

class RetinalScreeningScreen extends StatefulWidget {
  const RetinalScreeningScreen({super.key});
  @override
  State<RetinalScreeningScreen> createState() => _RetinalScreeningScreenState();
}

class _RetinalScreeningScreenState extends State<RetinalScreeningScreen>
    with SingleTickerProviderStateMixin {
  bool _disclaimerAccepted = false;
  bool _scanning = false;
  RetinalScreeningResult? _result;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _scan({bool fromCamera = true}) async {
    setState(() { _scanning = true; _result = null; });
    HapticFeedback.mediumImpact();
    final result = await RetinalAiService.instance.performScreening(fromCamera: fromCamera);
    if (mounted) setState(() { _scanning = false; _result = result; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('AI Retinal Screening', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          if (_result != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: () => setState(() { _result = null; _disclaimerAccepted = true; }),
            ),
        ],
      ),
      body: _disclaimerAccepted ? _scanningBody() : _disclaimerBody(),
    );
  }

  Widget _disclaimerBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        ScaleTransition(
          scale: _pulse,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withAlpha(80), blurRadius: 30, spreadRadius: 5)],
            ),
            child: const Icon(Icons.remove_red_eye, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 28),
        const Text('AI Eye Screening', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Powered by Gemini Vision AI', style: TextStyle(color: AppColors.cyan, fontSize: 14)),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF59E0B).withAlpha(80)),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B)),
              SizedBox(width: 10),
              Text('Important Disclaimer', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w700, fontSize: 16)),
            ]),
            SizedBox(height: 12),
            Text(
              'This AI screening tool is for EDUCATIONAL TRIAGE PURPOSES ONLY.\n\n'
              '• It is NOT a certified medical diagnostic device\n'
              '• Results CANNOT replace a professional ophthalmologist examination\n'
              '• Always consult a licensed eye doctor for any concerns\n'
              '• In case of sudden vision changes, seek emergency care immediately\n\n'
              'This tool is designed to raise awareness and prompt you to seek timely professional care.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        const Text('What we screen for:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: [
            _ConditionChip('👁️ Cataracts', const Color(0xFF0EA5E9)),
            _ConditionChip('🩸 Diabetic Retinopathy', const Color(0xFFEF4444)),
            _ConditionChip('💧 Glaucoma', const Color(0xFF10B981)),
            _ConditionChip('🔬 AMD', const Color(0xFF8B5CF6)),
            _ConditionChip('👁️‍🗨️ Conjunctivitis', const Color(0xFFF59E0B)),
          ],
        ),
        const SizedBox(height: 28),
        const Text('Tips for best results:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text(
          '• Use good lighting (face a bright window or lamp)\n'
          '• Hold phone 20–30cm from your eye\n'
          '• Remove glasses or contacts if possible\n'
          '• Keep the camera steady and eye wide open',
          style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 28),
        CheckboxListTile(
          value: false,
          onChanged: (v) => setState(() => _disclaimerAccepted = v == true),
          title: const Text('I understand this is an educational tool and not a medical diagnosis.',
              style: TextStyle(color: Colors.white, fontSize: 13)),
          checkColor: Colors.white,
          activeColor: AppColors.cyan,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.violet,
            disabledBackgroundColor: Colors.white12,
            minimumSize: const Size(double.infinity, 54),
          ),
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          label: const Text('Begin Screening', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        const Text('Check the box above to continue', style: TextStyle(color: Colors.white38, fontSize: 12)),
      ]),
    );
  }

  Widget _scanningBody() {
    if (_scanning) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ScaleTransition(
          scale: _pulse,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withAlpha(100), blurRadius: 40, spreadRadius: 10)],
            ),
            child: const Icon(Icons.remove_red_eye, size: 64, color: Colors.white),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Analyzing eye image...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Gemini Vision AI is processing', style: TextStyle(color: AppColors.cyan, fontSize: 14)),
        const SizedBox(height: 24),
        const CircularProgressIndicator(color: AppColors.cyan),
      ]));
    }

    if (_result == null) {
      return _captureBody();
    }

    return _resultBody();
  }

  Widget _captureBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          width: double.infinity, height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2235),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyan.withAlpha(60)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.camera_enhance, size: 64, color: AppColors.cyan),
            const SizedBox(height: 16),
            const Text('Position your eye in front of camera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Ensure good lighting for accurate analysis', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _scan(fromCamera: true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, minimumSize: const Size(0, 56)),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Use Camera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _scan(fromCamera: false),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 56)),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(12)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.lightbulb_outline, color: Color(0xFFF59E0B), size: 18),
            SizedBox(width: 10),
            Expanded(child: Text(
              'For best results: Take photo in a bright room, hold phone at arm\'s length, and look directly at the camera lens.',
              style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _resultBody() {
    final r = _result!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (r.imagePath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(File(r.imagePath!), width: double.infinity, height: 200, fit: BoxFit.cover),
          ),
        const SizedBox(height: 20),
        // Risk level banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: r.riskColor.withAlpha(25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: r.riskColor.withAlpha(100)),
          ),
          child: Column(children: [
            Text(r.riskEmoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(r.riskLabel, style: TextStyle(color: r.riskColor, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(r.primaryFinding, style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: r.confidence / 100,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(r.riskColor),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text('AI Confidence: ${r.confidence}%', style: TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ),
        const SizedBox(height: 20),
        if (r.conditionsDetected.isNotEmpty) ...[
          const Text('Findings Detected:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: r.conditionsDetected.map((c) =>
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: r.riskColor.withAlpha(25), borderRadius: BorderRadius.circular(20), border: Border.all(color: r.riskColor.withAlpha(80))),
              child: Text(c, style: TextStyle(color: r.riskColor, fontWeight: FontWeight.w600)),
            )
          ).toList()),
          const SizedBox(height: 20),
        ],
        if (r.recommendations.isNotEmpty) ...[
          const Text('Recommendations:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          ...r.recommendations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6, right: 10), decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
              Expanded(child: Text(rec, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))),
            ]),
          )),
          const SizedBox(height: 20),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF43F5E).withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF43F5E).withAlpha(60)),
          ),
          child: const Text(
            '⚠️ This is an AI-assisted educational triage. Results are NOT a medical diagnosis. Please consult a licensed ophthalmologist for professional evaluation.',
            style: TextStyle(color: Color(0xFFF43F5E), fontSize: 12, height: 1.5),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => setState(() { _result = null; }),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan, minimumSize: const Size(double.infinity, 54)),
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          label: const Text('Scan Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

class _ConditionChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ConditionChip(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withAlpha(80))),
    child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}
