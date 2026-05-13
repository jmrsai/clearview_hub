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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class HomeRemediesScreen extends StatelessWidget {
  const HomeRemediesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Care & Hygiene'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prevention & Remedies', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Evidence-based eye hygiene practices and home remedies for minor irritations.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            _buildRemedyCard(
              context,
              'Warm Compress',
              'Best for: Chalazion (stye), Meibomian Gland Dysfunction, Dry Eyes.',
              'Soak a clean cloth in warm water. Apply over closed eyelids for 5-10 minutes. Repeat 3-4 times a day.',
              Icons.thermostat,
              AppColors.warning,
            ),
            const SizedBox(height: 16),
            
            _buildRemedyCard(
              context,
              'Eyelid Hygiene (Lid Scrubs)',
              'Best for: Blepharitis, recurrent styes, preventing infections.',
              'Use a diluted baby shampoo or dedicated lid scrub on a cotton swab. Gently clean the base of the eyelashes to remove debris and oil.',
              Icons.clean_hands,
              AppColors.cyan,
            ),
            const SizedBox(height: 16),

            _buildRemedyCard(
              context,
              'UV Protection & Lubrication',
              'Best for: Pterygium, Pinguecula, general corneal health.',
              'Wear 100% UV-blocking sunglasses outdoors. Use preservative-free artificial tears if eyes feel dry or gritty.',
              Icons.wb_sunny,
              AppColors.success,
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'MEDICAL DISCLAIMER: Home remedies do not replace professional medical advice. If you experience severe pain, sudden vision loss, flashes, or floaters, consult an ophthalmologist immediately.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemedyCard(BuildContext context, String title, String indications, String instructions, IconData icon, Color color) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Text(indications, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(instructions, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
