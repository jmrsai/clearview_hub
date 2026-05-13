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

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class VisionSimulatorScreen extends StatefulWidget {
  const VisionSimulatorScreen({super.key});

  @override
  State<VisionSimulatorScreen> createState() => _VisionSimulatorScreenState();
}

class _VisionSimulatorScreenState extends State<VisionSimulatorScreen> {
  double _acuityValue = 1.0; // 1.0 = 20/20, 0.1 = 20/200

  String get _acuityText {
    if (_acuityValue >= 0.9) return '20/20 (Normal)';
    if (_acuityValue >= 0.7) return '20/40 (Mild)';
    if (_acuityValue >= 0.4) return '20/70 (Moderate)';
    if (_acuityValue >= 0.2) return '20/100 (Severe)';
    return '20/200 (Legal Blindness)';
  }

  double get _blurSigma {
    // Inverse relationship: lower acuity = higher blur
    // 20/20 (1.0) -> sigma 0
    // 20/200 (0.1) -> sigma 10
    return (1.0 - _acuityValue) * 12.0;
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Vision Simulator'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: AdaptiveCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1000&auto=format&fit=crop',
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _blurSigma,
                            sigmaY: _blurSigma,
                          ),
                          child: Container(
                            color: Colors.black.withAlpha(0),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Simulated Acuity: $_acuityText',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AdaptiveCard(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adjust Visual Acuity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Experience how different vision levels affect clarity.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: _acuityValue,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    activeColor: AppColors.cyan,
                    inactiveColor: AppColors.cyanDim,
                    onChanged: (val) => setState(() => _acuityValue = val),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('20/200', style: TextStyle(color: AppColors.textHint)),
                      Text('20/20', style: TextStyle(color: AppColors.textHint)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
