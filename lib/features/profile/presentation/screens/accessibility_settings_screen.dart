import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDyslexiaMode = ref.watch(dyslexiaModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility & Vision'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Customize EyeVerse to meet your visual needs. These settings apply globally across the application.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildSettingCard(
            title: 'Dyslexia Friendly Font',
            subtitle: 'Uses Lexend font with increased letter spacing and line height to improve readability.',
            icon: Icons.text_fields,
            trailing: Switch(
              value: isDyslexiaMode,
              onChanged: (val) {
                ref.read(dyslexiaModeProvider.notifier).state = val;
              },
              activeColor: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'High Contrast Mode',
            subtitle: 'Increases contrast between text and backgrounds (WCAG AAA).',
            icon: Icons.contrast,
            trailing: Switch(
              value: false, // Placeholder for future implementation
              onChanged: (val) {},
              activeColor: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'Color Blindness Filters',
            subtitle: 'Adjust colors for Protanopia, Deuteranopia, or Tritanopia.',
            icon: Icons.color_lens,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'Voice Navigation',
            subtitle: 'Enable AI voice commands to navigate without touching the screen.',
            icon: Icons.mic,
            trailing: Switch(
              value: false,
              onChanged: (val) {},
              activeColor: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.secondary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
