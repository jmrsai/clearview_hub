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
import '../../core/theme/app_colors.dart';

class WhoStandardsScreen extends StatelessWidget {
  const WhoStandardsScreen({super.key});

  static const String _complianceStatement = '''
ClearView Hub vision tests are designed to align with World Health Organization (WHO) eye care standards and the International Agency for the Prevention of Blindness (IAPB) guidelines.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('WHO Eye Standards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // WHO badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0050B3), Color(0xFF0EA5E9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const Text('🌐', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              const Text('WHO Aligned Platform', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(_complianceStatement, textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 24),
          // Global stats
          const Text('🌍 Global Vision Impact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 14),
          _StatCard('2.2 Billion', 'People globally with vision impairment', const Color(0xFFEF4444)),
          _StatCard('1 Billion', 'Cases that could have been prevented or treated', const Color(0xFFF59E0B)),
          _StatCard('90%', 'Of global vision impairment occurs in low-income countries', const Color(0xFF0EA5E9)),
          _StatCard('36 Million', 'People are blind worldwide', const Color(0xFF8B5CF6)),
          const SizedBox(height: 24),
          // Test standards
          const Text('📋 Test Accuracy Standards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 14),
          _StandardItem(
            title: 'Snellen Visual Acuity Chart',
            body: 'Our Snellen test follows standardized angular size calculation at 6 meters equivalent. Results provided in 6/x Snellen notation as per British Standards (BS 4274-1) and WHO recommendation.',
            icon: Icons.visibility,
            color: const Color(0xFF0EA5E9),
          ),
          _StandardItem(
            title: 'Amsler Grid (Macular Test)',
            body: 'Grid dimensions calibrated to subtend 20° at 28–30 cm working distance. Follows the original Marc Amsler design used in WHO early AMD detection protocols.',
            icon: Icons.grid_4x4,
            color: const Color(0xFF10B981),
          ),
          _StandardItem(
            title: 'Color Vision (Ishihara)',
            body: 'Plate presentation follows standard Ishihara test protocols. Limitations: screen color accuracy varies by device — results should be confirmed with physical plates by a professional.',
            icon: Icons.palette,
            color: const Color(0xFFEC4899),
          ),
          _StandardItem(
            title: 'AI Retinal Screening',
            body: 'Educational triage only. NOT a certified diagnostic test. Designed to increase awareness and encourage timely professional consultation. Fully aligned with WHO\'s early detection promotion goals.',
            icon: Icons.camera_enhance,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 24),
          // VISION 2030
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2D22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🎯 WHO VISION 2030 Goals', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              _VisionGoal('Reduce avoidable blindness by 25% by 2030'),
              _VisionGoal('Ensure universal access to basic eye care services'),
              _VisionGoal('Integrate eye health into primary health systems globally'),
              _VisionGoal('Develop the global eye care workforce by 30%'),
              const SizedBox(height: 12),
              Text('ClearView Hub contributes to this mission by making early detection accessible on every smartphone.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 20),
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(12)),
            child: const Text(
              '⚠️ ClearView Hub is a screening awareness tool and is NOT certified by WHO, IAPB, or any regulatory authority as a medical device. All tests are for educational purposes. Always consult a licensed ophthalmologist for diagnosis.',
              style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCard(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2235),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withAlpha(50)),
    ),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(8)),
        child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      const SizedBox(width: 14),
      Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
    ]),
  );
}

class _StandardItem extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  const _StandardItem({required this.title, required this.body, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(14)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(body, style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
      ])),
    ]),
  );
}

class _VisionGoal extends StatelessWidget {
  final String text;
  const _VisionGoal(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13))),
    ]),
  );
}
