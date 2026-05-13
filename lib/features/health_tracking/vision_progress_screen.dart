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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../models/vision_test_result.dart';

class VisionProgressScreen extends StatefulWidget {
  final String patientId;
  const VisionProgressScreen({super.key, required this.patientId});
  @override
  State<VisionProgressScreen> createState() => _VisionProgressScreenState();
}

class _VisionProgressScreenState extends State<VisionProgressScreen> {
  List<VisionTestResult> _snellen = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await DatabaseHelper.instance
        .getVisionTestsByType(widget.patientId, 'snellen');
    if (mounted) setState(() { _snellen = results; _loading = false; });
  }

  double _acuityToScore(String acuity) {
    // Convert 20/X to a 0-100 score: 20/20=100, 20/200=10
    final parts = acuity.split('/');
    if (parts.length != 2) return 50;
    final denom = double.tryParse(parts[1]) ?? 100;
    return (20 / denom * 100).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Vision Progress')),
      body: SafeArea(child: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
          : SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 70, 16, 16), child: Column(children: [
              Text('Visual Acuity Trend', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('Snellen chart results over time',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              if (_snellen.isEmpty)
                AdaptiveCard(child: Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(children: [
                    const Icon(Icons.show_chart, size: 48, color: AppColors.textHint),
                    const SizedBox(height: 12),
                    Text('No Snellen tests recorded yet.',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                )))
              else ...[
                AdaptiveCard(
                  child: SizedBox(height: 220, child: LineChart(_buildChart())),
                ),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _legend(AppColors.cyan, 'Left Eye'),
                  const SizedBox(width: 20),
                  _legend(AppColors.violet, 'Right Eye'),
                ]),
                const SizedBox(height: 20),
                ..._snellen.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AdaptiveCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(children: [
                      const Icon(Icons.visibility, color: AppColors.cyan, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_fmt(r.performedAt),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('${r.correctAnswers}/${r.totalQuestions} correct',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ])),
                      Column(children: [
                        Text(r.acuityLeft, style: const TextStyle(color: AppColors.cyan,
                            fontWeight: FontWeight.w700)),
                        Text(r.acuityRight, style: const TextStyle(color: AppColors.violet,
                            fontWeight: FontWeight.w700)),
                      ]),
                    ]),
                  ),
                )),
              ],
            ]))),
    );
  }

  LineChartData _buildChart() {
    final leftSpots = <FlSpot>[];
    final rightSpots = <FlSpot>[];
    for (int i = 0; i < _snellen.length; i++) {
      leftSpots.add(FlSpot(i.toDouble(), _acuityToScore(_snellen[i].acuityLeft)));
      rightSpots.add(FlSpot(i.toDouble(), _acuityToScore(_snellen[i].acuityRight)));
    }
    return LineChartData(
      backgroundColor: Colors.transparent,
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (_) => FlLine(color: AppColors.glassBorder, strokeWidth: 1),
        getDrawingVerticalLine: (_) => FlLine(color: AppColors.glassBorder, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 25,
            getTitlesWidget: (v, _) => Text('${v.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppColors.textHint)))),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        LineChartBarData(spots: leftSpots, color: AppColors.cyan, isCurved: true,
            barWidth: 2.5, dotData: FlDotData(show: true,
                getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                    radius: 4, color: AppColors.cyan, strokeWidth: 0))),
        LineChartBarData(spots: rightSpots, color: AppColors.violet, isCurved: true,
            barWidth: 2.5, dotData: FlDotData(show: true,
                getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                    radius: 4, color: AppColors.violet, strokeWidth: 0))),
      ],
      minY: 0, maxY: 100,
    );
  }

  Widget _legend(Color color, String label) {
    return Row(children: [
      Container(width: 16, height: 3, decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 6),
      Text(label, style: TextStyle(fontSize: 12, color: color)),
    ]);
  }

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}';
}
