import 'package:flutter/material.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class HomeRemediesScreen extends StatelessWidget {
  const HomeRemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Home Remedies'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDisclaimer(),
            const SizedBox(height: 24),
            _buildRemedyCard(
              title: 'Warm Compress',
              condition: 'For: Styes, Mild Dry Eye, Blocked Glands',
              description: 'Soak a clean washcloth in warm (not hot) water. Wring it out and place it over closed eyes for 5-10 minutes. This helps loosen clogged oil glands.',
              icon: Icons.hot_tub,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 16),
            _buildRemedyCard(
              title: 'Cold Compress',
              condition: 'For: Eye Allergies, Puffiness, Swelling',
              description: 'Wrap ice in a towel or use a chilled gel mask. Place over closed eyes for 10-15 minutes to constrict blood vessels and reduce swelling and itchiness.',
              icon: Icons.ac_unit,
              color: Colors.lightBlueAccent,
            ),
            const SizedBox(height: 16),
            _buildRemedyCard(
              title: 'The 20-20-20 Rule',
              condition: 'For: Digital Eye Strain, Fatigue',
              description: 'Every 20 minutes, look at something 20 feet away for at least 20 seconds. This relaxes the focusing muscles inside the eye.',
              icon: Icons.timer,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 16),
            _buildRemedyCard(
              title: 'Lid Hygiene (Scrub)',
              condition: 'For: Blepharitis, Crusty Eyelids',
              description: 'Use a gentle, tear-free baby shampoo diluted in warm water on a cotton swab. Gently scrub the base of your eyelashes to remove debris.',
              icon: Icons.clean_hands,
              color: Colors.pinkAccent,
            ),
            const SizedBox(height: 16),
            _buildRemedyCard(
              title: 'Hydration & Blinking',
              condition: 'For: General Dryness',
              description: 'Drink plenty of water. When using screens, we tend to blink 66% less. Make a conscious effort to perform full, complete blinks.',
              icon: Icons.water_drop,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Medical Disclaimer: These remedies are for mild, non-emergency conditions. If you experience severe pain, sudden vision loss, or symptoms persist, seek professional medical care immediately.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemedyCard({
    required String title,
    required String condition,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  condition,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
