import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';
import 'package:clearview_hub/widgets/glass_card.dart';
import 'package:clearview_hub/features/wellness_core/presentation/widgets/advanced_wellness_dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeTab = 0; // 0: Overview, 1: Global Wellness

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabSwitcher(),
              Expanded(
                child: _activeTab == 0
                    ? _buildOverviewTab(context)
                    : const AdvancedWellnessDashboard(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/emergency'),
        backgroundColor: AppColors.error,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const Text(
                'Alex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _tabButton('OVERVIEW', 0),
          const SizedBox(width: 12),
          _tabButton('WELLNESS', 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final active = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? Colors.cyan.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? Colors.cyan : Colors.white10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.cyan : Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthScoreRing(),
          const SizedBox(height: 24),
          _buildSectionHeader('Live Wellness Metrics'),
          _buildLiveMetricsGrid(),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 24),
          _buildSectionHeader('Community & Social Feed'),
          _buildCommunityQuickView(context),
          const SizedBox(height: 24),
          _buildExtraActions(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHealthScoreRing() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: 0.92,
                center: const Text(
                  '92',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                progressColor: AppColors.accent,
                backgroundColor: Colors.white10,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'SAFE',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eye Health Score',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  'Excellent',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your blink rate is optimal and distance is safe.',
                  style: TextStyle(fontSize: 11, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildMetricTile(
          'Focus Score',
          '85%',
          Icons.center_focus_strong,
          Colors.cyan,
        ),
        _buildMetricTile(
          'Posture',
          'Optimal',
          Icons.accessibility_new,
          Colors.teal,
        ),
        _buildMetricTile(
          'Blink Rate',
          '14/min',
          Icons.remove_red_eye,
          Colors.blue,
        ),
        _buildMetricTile('Screen Time', '4h 20m', Icons.timer, Colors.orange),
      ],
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityQuickView(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/community/feed'),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=600&h=200&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          opacity: 0.1,
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join 2.5k Members Online',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Share your focus session or join group therapy.',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                child: const Icon(Icons.arrow_forward, color: AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEyeHealthScoreCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 140,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.2),
          AppColors.accent.withValues(alpha: 0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [AppColors.accent.withValues(alpha: 0.5), Colors.transparent],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eye Health Score',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '92/100',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Excellent condition',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.92,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  color: AppColors.accent,
                ),
              ),
              const Icon(
                Icons.remove_red_eye,
                color: AppColors.accent,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildActionItem(
            context,
            'AI Scan',
            Icons.document_scanner,
            AppColors.secondary,
            '/eye_scanner',
          ),
          _buildActionItem(
            context,
            'Safety',
            Icons.security,
            AppColors.warning,
            '/distance_monitor',
          ),
          _buildActionItem(
            context,
            'Exercises',
            Icons.fitness_center,
            Colors.greenAccent,
            '/exercises',
          ),
          _buildActionItem(
            context,
            'Clinic',
            Icons.local_hospital,
            Colors.orangeAccent,
            '/clinic',
          ),
          _buildActionItem(
            context,
            'Analytics',
            Icons.bar_chart,
            Colors.purpleAccent,
            '/analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildExtraActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildWideAction(
              context,
              'Triage',
              Icons.healing,
              Colors.redAccent,
              '/symptom_triage',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Home Remedies',
              Icons.spa,
              Colors.greenAccent,
              '/home_remedies',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Dry Eye Test',
              Icons.opacity,
              Colors.blueAccent,
              '/dry_eye_test',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Encyclopedia',
              Icons.menu_book,
              Colors.amberAccent,
              '/eye_encyclopedia',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Magnifier',
              Icons.search,
              Colors.cyanAccent,
              '/magnifier',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Color ID',
              Icons.color_lens,
              Colors.purpleAccent,
              '/color_identifier',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Addiction Test',
              Icons.assessment,
              Colors.redAccent,
              '/digital_addiction_test',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Meditation',
              Icons.self_improvement,
              Colors.cyanAccent,
              '/guided_meditation',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Blink Game',
              Icons.remove_red_eye,
              Colors.lightGreenAccent,
              '/blink_speed_game',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Palming',
              Icons.pan_tool,
              Colors.orangeAccent,
              '/palming_exercise',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Travel Wellness',
              Icons.directions_car,
              Colors.cyan,
              '/motion_wellness',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Detox Mode',
              Icons.phonelink_off,
              Colors.orange,
              '/digital_wellbeing',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Sleep Guard',
              Icons.bedtime,
              Colors.indigoAccent,
              '/sleep_protection',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'AI Assistant',
              Icons.auto_awesome,
              Colors.pinkAccent,
              '/ai_assistant',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Wellness Reels',
              Icons.video_collection,
              Colors.purpleAccent,
              '/wellness_reels',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'AR Try-On',
              Icons.face,
              Colors.tealAccent,
              '/virtual_try_on',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Teleophthalmology',
              Icons.video_camera_front,
              Colors.lightBlueAccent,
              '/teleophthalmology',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'App Lock',
              Icons.fingerprint,
              Colors.redAccent,
              '/biometric_lock',
            ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Clinical Report',
              Icons.summarize,
              Colors.blueAccent,
              '/clinical_report',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Surface Scan (Infection)',
              Icons.camera_front,
              Colors.greenAccent,
              '/eye_scanner/surface_scan',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildWideAction(
              context,
              'Eye Drops',
              Icons.water_drop,
              Colors.cyanAccent,
              '/medication_tracker',
            ),
            const SizedBox(width: 12),
            _buildWideAction(
              context,
              'Quantum Superbrain',
              Icons.public,
              Colors.purpleAccent,
              '/global_quantum_network',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWideAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ai_assistant'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 40),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EyeVerse AI Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Need wellness tips or travel help?',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenTimeAndTherapy() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, color: Colors.white70),
                SizedBox(height: 8),
                Text(
                  'Screen Time',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '4h 20m',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department, color: AppColors.warning),
                SizedBox(height: 8),
                Text(
                  'Therapy Streak',
                  style: TextStyle(color: AppColors.warning, fontSize: 12),
                ),
                Text(
                  '12 Days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
