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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'snellen_chart_screen.dart';
import 'amsler_grid_screen.dart';
import 'color_blindness_screen.dart';
import '../diagnostics/disease_screening_screen.dart';

class VisionTestsHub extends StatelessWidget {
  final String patientId;
  const VisionTestsHub({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Vision Tests')),
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Select a Test', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text('Tap any test to begin. Cover one eye at a time when prompted.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        _TestCard(
          icon: Icons.format_size,
          title: 'Snellen Chart',
          subtitle: 'Measure visual acuity (20/20, 20/40…)',
          gradient: AppColors.primaryGradient,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => SnellenChartScreen(patientId: patientId)));
          },
        ),
        const SizedBox(height: 16),
        _TestCard(
          icon: Icons.grid_on,
          title: 'Amsler Grid',
          subtitle: 'Detect macular degeneration & central vision distortion',
          gradient: const LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => AmslerGridScreen(patientId: patientId)));
          },
        ),
        const SizedBox(height: 16),
        _TestCard(
          icon: Icons.palette,
          title: 'Color Blindness',
          subtitle: 'Ishihara-style test for red-green & blue-yellow deficiencies',
          gradient: const LinearGradient(colors: [Color(0xFF065F46), Color(0xFF10B981)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ColorBlindnessScreen(patientId: patientId)));
          },
        ),
        const SizedBox(height: 16),
        _TestCard(
          icon: Icons.biotech,
          title: 'AI Eye Screening',
          subtitle: 'Classify Cataract, Glaucoma, & Retinopathy using AI',
          gradient: const LinearGradient(colors: [Color(0xFFBE123C), Color(0xFFF43F5E)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => DiseaseScreeningScreen(patientId: patientId)));
          },
        ),
        const SizedBox(height: 32),
        AdaptiveCard(
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.cyan, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(
              'These tests are for screening only and do not replace a professional eye exam.',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
          ]),
        ),
      ])),
    );
  }
}

class _TestCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;
  const _TestCard({required this.icon, required this.title, required this.subtitle,
      required this.gradient, required this.onTap});
  @override
  State<_TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<_TestCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))],
          ),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
              child: Icon(widget.icon, color: Colors.white, size: 28)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                  color: Colors.white)),
              const SizedBox(height: 4),
              Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: Colors.white70)),
            ])),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ]),
        ),
      ),
    );
  }
}
