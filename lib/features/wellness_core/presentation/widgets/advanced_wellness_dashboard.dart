import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:battery_plus/battery_plus.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../ai_engine/domain/global_wellness_engine.dart';
import '../../../../sensors/domain/sensor_orchestrator.dart';

class AdvancedWellnessDashboard extends ConsumerStatefulWidget {
  const AdvancedWellnessDashboard({super.key});

  @override
  ConsumerState<AdvancedWellnessDashboard> createState() =>
      _AdvancedWellnessDashboardState();
}

class _AdvancedWellnessDashboardState extends ConsumerState<AdvancedWellnessDashboard> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBattery();
  }

  void _getBattery() async {
    final level = await _battery.batteryLevel;
    setState(() => _batteryLevel = level);
  }

  @override
  Widget build(BuildContext context) {
    final wellnessState = ref.watch(globalWellnessEngineProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGlobalWellnessScore(wellnessState),
          const SizedBox(height: 24),
          _buildSensorStatusRow(),
          const SizedBox(height: 24),
          const Text(
            'Live Metrics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildLiveMetricsGrid(wellnessState),
          const SizedBox(height: 24),
          _buildDailyActivityChart(),
        ],
      ),
    );
  }

  Widget _buildGlobalWellnessScore(WellnessState state) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: state.globalScore / 100.0,
            center: Text(
              state.globalScore.toInt().toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            progressColor: _getColorForScore(state.globalScore),
            backgroundColor: Colors.white10,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animateFromLastPercent: true,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Digital Wellness Score',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTextForScore(state.globalScore),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getColorForScore(state.globalScore),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.recommendation,
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 80) return Colors.greenAccent;
    if (score >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _getTextForScore(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 50) return 'Moderate Risk';
    return 'Critical Risk';
  }

  Widget _buildSensorStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSmallSensorCard(
          'Battery',
          '$_batteryLevel%',
          Icons.battery_std,
          Colors.greenAccent,
        ),
        _buildSmallSensorCard(
          'Light',
          '450 lx',
          Icons.wb_sunny,
          Colors.orangeAccent,
        ),
        _buildSmallSensorCard(
          'Signal',
          'Strong',
          Icons.wifi,
          Colors.blueAccent,
        ),
      ],
    );
  }

  Widget _buildSmallSensorCard(
    String label,
    String val,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetricsGrid(WellnessState state) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard('Eye Strain', '${state.eyeStrainScore.toInt()}%', Icons.visibility, Colors.cyan),
        _buildMetricCard(
          'Posture',
          '${state.postureHealth.toInt()}%',
          Icons.accessibility_new,
          Colors.teal,
        ),
        _buildMetricCard('Mental Fatigue', '${state.mentalFatigueIndex.toInt()}%', Icons.psychology, Colors.indigoAccent),
        _buildMetricCard('Active Mode', state.activeMode, Icons.mode, Colors.blue),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String val,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            val,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivityChart() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wellness Activity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                      const FlSpot(5, 3),
                      const FlSpot(6, 4),
                    ],
                    isCurved: true,
                    color: Colors.cyanAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                    ),
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
