import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../../core/theme/app_colors.dart';

class VisionTestsDashboard extends StatelessWidget {
  const VisionTestsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vision Testing Suite')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTestCard(
            context,
            'Visual Acuity',
            'Standard Snellen chart test with voice recognition.',
            Icons.text_format,
            AppColors.secondary,
            '/vision_lab/acuity',
          ),
          _buildTestCard(
            context,
            'Color Blindness',
            'Ishihara color plate test.',
            Icons.color_lens,
            AppColors.accent,
            '/vision_lab/color_blindness',
          ),
          _buildTestCard(
            context,
            'Astigmatism',
            'Radial dial line test for cornea curvature.',
            Icons.blur_circular,
            AppColors.info,
            '/vision_lab/astigmatism',
          ),
          _buildTestCard(
            context,
            'Amsler Grid',
            'Detect macular degeneration and central vision loss.',
            Icons.grid_4x4,
            AppColors.warning,
            '/vision_lab/amsler_grid',
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String? route,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            context.push(route);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Test coming soon!')));
          }
        },
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 120,
          borderRadius: 20,
          blur: 15,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.5),
              color.withValues(alpha: 0.1),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.play_arrow, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
