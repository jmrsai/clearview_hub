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
import 'package:fl_chart/fl_chart.dart';
import '../../core/services/wellness_service.dart';
import '../../core/theme/app_colors.dart';

class DigitalWellnessDashboard extends StatelessWidget {
  const DigitalWellnessDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Digital Wellness', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          Text('Eye health for screen users', style: TextStyle(color: AppColors.cyan, fontSize: 11)),
        ]),
      ),
      body: ListenableBuilder(
        listenable: WellnessService.instance,
        builder: (context, _) {
          final svc = WellnessService.instance;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Strain Score Ring
              _StrainScoreCard(score: svc.eyeStrainScore, label: svc.strainLabel, color: svc.strainColor),
              const SizedBox(height: 20),
              // Suggestion banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(svc.currentSuggestion, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
              ),
              const SizedBox(height: 20),
              // Metrics grid
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
                children: [
                  _MetricCard(
                    icon: Icons.timer, label: 'Screen Time',
                    value: _formatTime(svc.screenTimeMinutes),
                    color: const Color(0xFF0EA5E9),
                    subtitle: 'Today',
                  ),
                  _MetricCard(
                    icon: Icons.remove_red_eye, label: 'Blink Rate',
                    value: '${svc.blinkRatePerMinute.toStringAsFixed(1)}/min',
                    color: const Color(0xFF10B981),
                    subtitle: 'Normal: 12–15/min',
                  ),
                  _MetricCard(
                    icon: Icons.self_improvement, label: 'Breaks Taken',
                    value: '${svc.breaksTaken}',
                    color: const Color(0xFFF59E0B),
                    subtitle: 'Rest sessions',
                  ),
                  _MetricCard(
                    icon: Icons.bolt, label: 'Blinks Today',
                    value: '${svc.blinkCount}',
                    color: const Color(0xFF8B5CF6),
                    subtitle: 'Total recorded',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('7-Day Eye Strain Trend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 14),
              _WeeklyChart(data: svc.weeklyData),
              const SizedBox(height: 24),
              // WHO recommendation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF003322),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Text('🌐', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('WHO Eye Health Guidelines', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700, fontSize: 14)),
                  ]),
                  const SizedBox(height: 12),
                  _WHOItem('Limit continuous screen use to 2 hours max'),
                  _WHOItem('Follow the 20-20-20 rule: every 20 min, look 20 feet away for 20 sec'),
                  _WHOItem('Maintain blink rate of 12–15 blinks per minute'),
                  _WHOItem('Get annual eye exams regardless of symptoms'),
                ]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => WellnessService.instance.recordBreak(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, minimumSize: const Size(double.infinity, 54)),
                icon: const Icon(Icons.self_improvement, color: Colors.white),
                label: const Text('I Took a Break (20-20-20)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ]),
          );
        },
      ),
    );
  }

  String _formatTime(int minutes) {
    if (minutes < 60) return '${minutes}m';
    return '${(minutes / 60).floor()}h ${minutes % 60}m';
  }
}

class _StrainScoreCard extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  const _StrainScoreCard({required this.score, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withAlpha(30), const Color(0xFF1E2235)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(children: [
        SizedBox(
          width: 100, height: 100,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 10,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$score', style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900)),
              Text('/100', style: TextStyle(color: color.withAlpha(150), fontSize: 10)),
            ]),
          ]),
        ),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Eye Strain Score', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Based on screen time, blink rate, and break compliance.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
        ])),
      ]),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String subtitle;
  const _MetricCard({required this.icon, required this.label, required this.value, required this.color, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2235),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withAlpha(50)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const Spacer(),
      Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
      Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
      Text(subtitle, style: TextStyle(color: AppColors.textHint, fontSize: 10)),
    ]),
  );
}

class _WeeklyChart extends StatelessWidget {
  final List<DailyWellness> data;
  const _WeeklyChart({required this.data});
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(16)),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(data[idx].dayLabel, style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(data.length, (i) {
            final score = data[i].strainScore.toDouble();
            final color = score < 25 ? const Color(0xFF10B981) : score < 50 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: score == 0 ? 2 : score, // min bar height
                color: color,
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ]);
          }),
          maxY: 100,
        ),
      ),
    );
  }
}

class _WHOItem extends StatelessWidget {
  final String text;
  const _WHOItem(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('• ', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700)),
      Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5))),
    ]),
  );
}
