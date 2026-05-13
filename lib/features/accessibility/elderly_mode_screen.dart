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
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

/// High-contrast accessibility mode for elderly users with voice narration.
class ElderlyModeScreen extends StatefulWidget {
  const ElderlyModeScreen({super.key});
  @override
  State<ElderlyModeScreen> createState() => _ElderlyModeScreenState();
}

class _ElderlyModeScreenState extends State<ElderlyModeScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _voiceEnabled = true;
  double _fontSize = 22;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak('Welcome to Easy View Mode. Your eye health simplified.'));
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(0.9);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _voiceEnabled = prefs.getBool('elderly_voice') ?? true;
        _fontSize = prefs.getDouble('elderly_font_size') ?? 22;
      });
    }
  }

  Future<void> _speak(String text) async {
    if (_voiceEnabled) await _tts.speak(text);
  }

  @override
  void dispose() { _tts.stop(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _elderlyTheme(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Easy View Mode', style: TextStyle(color: Colors.yellow, fontSize: _fontSize, fontWeight: FontWeight.w800)),
          actions: [
            IconButton(
              icon: Icon(_voiceEnabled ? Icons.volume_up : Icons.volume_off, color: Colors.yellow),
              onPressed: () async {
                setState(() => _voiceEnabled = !_voiceEnabled);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('elderly_voice', _voiceEnabled);
                if (_voiceEnabled) _speak('Voice guide turned on');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Font size slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1A1A00), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.yellow.withAlpha(80))),
              child: Column(children: [
                Text('Text Size', style: TextStyle(color: Colors.yellow, fontSize: _fontSize * 0.8, fontWeight: FontWeight.w700)),
                Slider(
                  value: _fontSize,
                  min: 16, max: 32,
                  activeColor: Colors.yellow,
                  onChanged: (v) async {
                    setState(() => _fontSize = v);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('elderly_font_size', v);
                  },
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('A', style: TextStyle(color: Colors.yellow.withAlpha(150), fontSize: 14)),
                  Text('A', style: TextStyle(color: Colors.yellow, fontSize: 28, fontWeight: FontWeight.w700)),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            // Main actions — large, easy to tap
            _ElderlyButton(
              emoji: '💊',
              label: 'My Medicines',
              fontSize: _fontSize,
              onTap: () => _speak('Opening your medication list.'),
            ),
            _ElderlyButton(
              emoji: '👁️',
              label: 'Eye Test',
              fontSize: _fontSize,
              onTap: () => _speak('Opening eye tests.'),
            ),
            _ElderlyButton(
              emoji: '📞',
              label: 'Call My Doctor',
              fontSize: _fontSize,
              color: Colors.green,
              onTap: () => _speak('Opening telemedicine to call your doctor.'),
            ),
            _ElderlyButton(
              emoji: '🆘',
              label: 'Emergency',
              fontSize: _fontSize,
              color: Colors.red,
              onTap: () {
                HapticFeedback.vibrate();
                _speak('Calling emergency contact.');
              },
            ),
            const SizedBox(height: 24),
            // Eye drop reminder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF001A33),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade300.withAlpha(120), width: 2),
              ),
              child: Column(children: [
                Text('💧 Eye Drops Schedule', style: TextStyle(color: Colors.blue.shade200, fontSize: _fontSize, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                _DropRow('Morning', '08:00 AM', 'Timolol 0.5%', _fontSize),
                _DropRow('Evening', '08:00 PM', 'Latanoprost 0.005%', _fontSize),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () => _speak('Eye drop reminders are active. You will be notified.'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, minimumSize: const Size(double.infinity, 56)),
                  icon: const Icon(Icons.alarm, color: Colors.white),
                  label: Text('Manage Reminders', style: TextStyle(color: Colors.white, fontSize: _fontSize * 0.75, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            // Vision tips
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0028),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.violet.withAlpha(100)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('👁️ Daily Vision Tips', style: TextStyle(color: Colors.purple.shade200, fontSize: _fontSize * 0.9, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _TipItem('Wear sunglasses outdoors to protect from UV.', _fontSize),
                _TipItem('Eat leafy greens and carrots for eye health.', _fontSize),
                _TipItem('Get a complete eye exam at least once a year.', _fontSize),
                _TipItem('Report sudden vision changes to your doctor immediately.', _fontSize),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  ThemeData _elderlyTheme() => ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(primary: Colors.yellow, secondary: Colors.blue),
  );
}

class _ElderlyButton extends StatelessWidget {
  final String emoji;
  final String label;
  final double fontSize;
  final Color color;
  final VoidCallback onTap;
  const _ElderlyButton({required this.emoji, required this.label, required this.fontSize, this.color = Colors.yellow, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.mediumImpact(); onTap(); },
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(18),
        color: color.withAlpha(20),
      ),
      child: Row(children: [
        Text(emoji, style: TextStyle(fontSize: fontSize * 1.4)),
        const SizedBox(width: 20),
        Text(label, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w800)),
      ]),
    ),
  );
}

class _DropRow extends StatelessWidget {
  final String time;
  final String clock;
  final String medicine;
  final double fontSize;
  const _DropRow(this.time, this.clock, this.medicine, this.fontSize);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(8)),
        child: Text(clock, style: TextStyle(color: Colors.blue.shade200, fontWeight: FontWeight.w700, fontSize: fontSize * 0.7)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text('$time — $medicine', style: TextStyle(color: Colors.white, fontSize: fontSize * 0.75))),
    ]),
  );
}

class _TipItem extends StatelessWidget {
  final String tip;
  final double fontSize;
  const _TipItem(this.tip, this.fontSize);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('•', style: TextStyle(color: Colors.purple.shade200, fontSize: fontSize, fontWeight: FontWeight.w800)),
      const SizedBox(width: 10),
      Expanded(child: Text(tip, style: TextStyle(color: Colors.white70, fontSize: fontSize * 0.75, height: 1.5))),
    ]),
  );
}
