import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class HealthAnalyticsDashboard extends StatelessWidget {
  const HealthAnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Eye Health Insights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          _buildStreakCard(),
          const SizedBox(height: 24),
          _buildBlinkRateChart(),
          const SizedBox(height: 24),
          _buildScreenTimeCorrelation(),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 50),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('7 Day Streak!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('You saved 140 minutes of eye strain this week.', style: TextStyle(color: Colors.white.withOpacity(0.7))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlinkRateChart() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Blink Rate (per min)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 12),
                      const FlSpot(1, 15),
                      const FlSpot(2, 10),
                      const FlSpot(3, 18),
                      const FlSpot(4, 14),
                      const FlSpot(5, 20),
                      const FlSpot(6, 16),
                    ],
                    isCurved: true,
                    color: AppColors.secondary,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: true, color: AppColors.secondary.withOpacity(0.2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenTimeCorrelation() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fatigue Correlation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.brightness_medium, 'Ambient Light', 'Optimized'),
          const Divider(color: Colors.white10),
          _buildInfoRow(Icons.timer, 'Avg. Session', '45 mins'),
          const Divider(color: Colors.white10),
          _buildInfoRow(Icons.warning_amber_rounded, 'Posture Alerts', '4 today'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
