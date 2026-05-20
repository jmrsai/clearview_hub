import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/glass_card.dart';

class EyeHealthAnalyticsScreen extends StatelessWidget {
  const EyeHealthAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eye Health Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildScoreCard(),
            const SizedBox(height: 20),
            _buildUsageChart(),
            const SizedBox(height: 20),
            _buildFatigueTrends(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement PDF Export
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF Report'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Your Eye Health Score',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            '85 / 100',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.cyan.shade300,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Excellent! Keep up the good habits.',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screen Usage (Last 7 Days)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: 5, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 7, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: 4, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: 8, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [BarChartRodData(toY: 6, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [BarChartRodData(toY: 3, color: Colors.cyan)],
                  ),
                  BarChartGroupData(
                    x: 6,
                    barRods: [BarChartRodData(toY: 5, color: Colors.cyan)],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFatigueTrends() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fatigue Trends',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 2),
                      const FlSpot(3, 5),
                      const FlSpot(4, 3),
                      const FlSpot(5, 4),
                      const FlSpot(6, 3),
                    ],
                    isCurved: true,
                    color: Colors.redAccent,
                    barWidth: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
