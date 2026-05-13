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
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../games/smooth_pursuit_wrapper.dart';
import 'blink_master_exercise.dart';
import 'focus_switch_exercise.dart';
import 'mfbf_therapy_game.dart';
import 'visual_perception_game.dart';
import 'saccadic_trainer_game.dart';
import 'therapy_scoreboard_screen.dart';
import 'games/contrast_sensitivity_game.dart';
import 'games/ishihara_test_game.dart';

class EyeTherapyHub extends StatelessWidget {
  final String patientId;
  const EyeTherapyHub({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Eye Therapy & Gym')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
          children: [
            _sectionHeader(context, 'Neuromuscular Training'),
            _exerciseCard(
              context,
              title: 'Follow the Dot',
              subtitle: 'Smooth Pursuit Tracking',
              icon: Icons.track_changes,
              color: AppColors.cyan,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => SmoothPursuitWrapper(patientId: patientId),
              )),
            ),
            _exerciseCard(
              context,
              title: 'Fast Tracking',
              subtitle: 'Saccadic Movement Trainer',
              icon: Icons.bolt,
              color: AppColors.cyan,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => SaccadicTrainerScreen(patientId: patientId),
              )),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, 'Wellness & Prevention'),
            _exerciseCard(
              context,
              title: 'Blink Master',
              subtitle: 'Dry Eye Prevention',
              icon: Icons.remove_red_eye_outlined,
              color: AppColors.teal,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => BlinkMasterExercise(patientId: patientId),
              )),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, 'Accommodative Facility'),
            _exerciseCard(
              context,
              title: 'Focus Switch',
              subtitle: 'Near-Far Training',
              icon: Icons.center_focus_strong,
              color: AppColors.violet,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => FocusSwitchExercise(patientId: patientId),
              )),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, 'Dichoptic Therapy (Amblyopia)'),
            _exerciseCard(
              context,
              title: 'MFBF Therapy',
              subtitle: 'Red-Cyan Anaglyph Game',
              icon: Icons.remove_red_eye,
              color: AppColors.error,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => MfbfTherapyGame(patientId: patientId),
              )),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, 'Diagnostic Screenings'),
            _exerciseCard(
              context,
              title: 'Contrast Sensitivity',
              subtitle: 'Background Separation',
              icon: Icons.brightness_6,
              color: AppColors.cyan,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const ContrastSensitivityGame(),
              )),
            ),
            _exerciseCard(
              context,
              title: 'Ishihara Test',
              subtitle: 'Color Vision Screening',
              icon: Icons.palette,
              color: AppColors.violet,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const IshiharaTestGame(),
              )),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, 'Visual Memory & Search'),
            _exerciseCard(
              context,
              title: 'Visual Perception',
              subtitle: 'Discrimination Puzzle',
              icon: Icons.grid_view,
              color: AppColors.success,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => VisualPerceptionGame(patientId: patientId),
              )),
            ),
            const SizedBox(height: 32),
            _actionButton(
              context,
              label: 'View Therapy Progress',
              icon: Icons.bar_chart,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => TherapyScoreboardScreen(patientId: patientId),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cyanDim.withValues(alpha: 0.1),
        foregroundColor: AppColors.cyan,
        side: BorderSide(color: AppColors.cyan.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
      ),
    );
  }

  Widget _exerciseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AdaptiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.textHint, size: 16),
        ],
      ),
    );
  }
}
