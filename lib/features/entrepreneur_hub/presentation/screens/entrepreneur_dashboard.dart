import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class EntrepreneurDashboard extends ConsumerWidget {
  const EntrepreneurDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Health Entrepreneur Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.business_center),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),
            const SizedBox(height: 24),
            const Text('Management Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            _buildToolsGrid(),
            const SizedBox(height: 32),
            const Text('Business Insights (AI)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            _buildInsightsCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Register Clinic'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch, size: 50, color: AppColors.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome, Innovator', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Manage your clinic, reach more patients, and grow your eye-care startup.', style: TextStyle(color: Colors.white.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid() {
    final tools = [
      {'title': 'Appointments', 'icon': Icons.calendar_month, 'color': Colors.blue},
      {'title': 'Patient CRM', 'icon': Icons.people, 'color': Colors.green},
      {'title': 'Analytics', 'icon': Icons.analytics, 'color': Colors.purple},
      {'title': 'Marketing', 'icon': Icons.campaign, 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return GlassCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tool['icon'] as IconData, size: 36, color: tool['color'] as Color),
              const SizedBox(height: 12),
              Text(tool['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text('AI Suggestion', style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Based on local patient searches, there is a 40% increase in queries for "Computer Vision Syndrome" in your area. Consider updating your clinic profile to highlight these treatments.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
