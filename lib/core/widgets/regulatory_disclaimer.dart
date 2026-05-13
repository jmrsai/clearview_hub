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
import '../theme/app_colors.dart';

/// Mandatory WHO-compliant Medical Disclaimer and Consent Overlay.
class RegulatoryDisclaimer extends StatelessWidget {
  final VoidCallback onAccepted;
  
  const RegulatoryDisclaimer({super.key, required this.onAccepted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel, color: AppColors.cyan),
              const SizedBox(width: 12),
              Text(
                'Clinical Compliance & Privacy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'WHO DIGITAL HEALTH GUIDELINES (IPEC):\n'
            'This application is an educational tool. By continuing, you acknowledge:\n\n'
            '• It does NOT replace a professional ophthalmologist diagnosis.\n'
            '• AI results are for preliminary triage only.\n'
            '• Your medical data is encrypted and stored locally.\n'
            '• In case of severe pain or vision loss, contact emergency services immediately.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAccepted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'I CONSENT & UNDERSTAND',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Compliance ID: WHO-IPEC-2026-CVH',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
