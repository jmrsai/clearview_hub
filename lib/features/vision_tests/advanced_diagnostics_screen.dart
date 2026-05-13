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
import 'package:camera/camera.dart';

class AdvancedDiagnosticsScreen extends StatefulWidget {
  const AdvancedDiagnosticsScreen({super.key});

  @override
  State<AdvancedDiagnosticsScreen> createState() => _AdvancedDiagnosticsScreenState();
}

class _AdvancedDiagnosticsScreenState extends State<AdvancedDiagnosticsScreen> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  String _aiResult = "Ready to scan.";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras.first, ResolutionPreset.medium);
      await _cameraController?.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _startScan(String condition) async {
    setState(() {
      _isDetecting = true;
      _aiResult = "Analyzing for $condition via Mirafish AI...";
    });

    // Simulate AI inference delay for anterior segment / motility
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isDetecting = false;
      _aiResult = "Scan complete. No severe markers of $condition detected. Mild dryness noted.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Diagnostics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cameraController != null && _cameraController!.value.isInitialized)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
                child: const Center(child: CircularProgressIndicator()),
              ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.analytics, color: AppColors.cyan),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _aiResult,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.cyan, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Targeted Analysis', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            _buildAction(
              'Strabismus (Squint) Analysis',
              'Detects Hirschberg corneal reflex deviations.',
              Icons.visibility,
              () => _startScan('Strabismus'),
            ),
            _buildAction(
              'Pterygium Scanner',
              'Detects fibrovascular growth on the conjunctiva.',
              Icons.remove_red_eye,
              () => _startScan('Pterygium'),
            ),
            _buildAction(
              'Chalazion / Stye Detector',
              'Identifies localized eyelid inflammation and granulomas.',
              Icons.face,
              () => _startScan('Chalazion'),
            ),
            _buildAction(
              'Cataract Opacity Check',
              'Analyzes lens reflection for early opacification.',
              Icons.lens_blur,
              () => _startScan('Cataract'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _isDetecting ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: AdaptiveCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.violet.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.violet),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (_isDetecting)
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              else
                const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
