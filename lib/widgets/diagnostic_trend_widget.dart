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
import '../core/theme/app_colors.dart';
import '../models/vision_test_result.dart';

class DiagnosticTrendWidget extends StatelessWidget {
  final List<VisionTestResult> results;
  final String title;

  const DiagnosticTrendWidget({
    super.key,
    required this.results,
    this.title = 'Vision Acuity Trend',
  });

  double _acuityToScore(String acuity) {
    final parts = acuity.split('/');
    if (parts.length != 2) return 50;
    final denom = double.tryParse(parts[1]) ?? 100;
    return (20 / denom * 100).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    final leftSpots = <FlSpot>[];
    final rightSpots = <FlSpot>[];
    for (int i = 0; i < results.length; i++) {
      leftSpots.add(FlSpot(i.toDouble(), _acuityToScore(results[i].acuityLeft)));
      rightSpots.add(FlSpot(i.toDouble(), _acuityToScore(results[i].acuityRight)));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: leftSpots,
                    isCurved: true,
                    color: AppColors.cyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.cyan.withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: rightSpots,
                    isCurved: true,
                    color: AppColors.violet,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.violet.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                minY: 0,
                maxY: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
