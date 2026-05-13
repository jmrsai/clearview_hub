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
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../therapy/aqueous_flow_simulator.dart';
import 'biodigital_viewer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

class EyeAnatomy3DViewer extends StatefulWidget {
  const EyeAnatomy3DViewer({super.key});

  @override
  State<EyeAnatomy3DViewer> createState() => _EyeAnatomy3DViewerState();
}

class _EyeAnatomy3DViewerState extends State<EyeAnatomy3DViewer> {
  final Flutter3DController _controller = Flutter3DController();

  // For production, use a bundled medical model: 'assets/models/human_eye.glb'
  final String _eyeModelUrl =
      'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AdaptiveScaffold(
        appBar: AppBar(
          title: const Text('3D Eye Anatomy'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.view_in_ar), text: 'Standard 3D'),
              Tab(icon: Icon(Icons.workspace_premium), text: 'Premium Anatomy'),
            ],
            indicatorColor: AppColors.cyan,
            labelColor: AppColors.cyan,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.resetCameraTarget();
                _controller.resetCameraOrbit();
              },
              tooltip: 'Reset View',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Standard 3D View
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Flutter3DViewer(
                        controller: _controller,
                        src: _eyeModelUrl,
                        progressBarColor: Colors.cyan,
                      ),
                      const Positioned(
                        bottom: 10,
                        right: 10,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: AqueousFlowSimulator(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AdaptiveCard(
                    margin: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eye Structure: Chambers',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.cyan),
                          ),
                          const SizedBox(height: 12),
                          _buildChamberInfo(
                            context,
                            'Anterior Chamber',
                            'The space between the cornea and the iris. It is filled with aqueous humor, which provides nutrients to the cornea and lens.',
                          ),
                          const SizedBox(height: 12),
                          _buildChamberInfo(
                            context,
                            'Posterior Chamber',
                            'A narrow space behind the iris and in front of the lens. It is also filled with aqueous humor.',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aqueous Humor Flow',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Produced by the ciliary body, aqueous humor flows from the posterior chamber through the pupil into the anterior chamber, and drains through the trabecular meshwork into the Canal of Schlemm.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Text(
                            'Source: MSD Manual Professional Edition',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Premium Anatomy View (BioDigital)
            const BioDigitalViewer(),
          ],
        ),
      ),
    );
  }

  Widget _buildChamberInfo(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(description, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
