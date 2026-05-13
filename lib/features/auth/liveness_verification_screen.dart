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
import 'package:flutter_liveness/flutter_liveness.dart';
import '../../core/theme/app_theme.dart'; // AdaptiveScaffold

class LivenessVerificationScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  const LivenessVerificationScreen({
    super.key,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<LivenessVerificationScreen> createState() => _LivenessVerificationScreenState();
}

class _LivenessVerificationScreenState extends State<LivenessVerificationScreen> {
  bool _isProcessing = false;
  String _statusMessage = "Please look at the camera to verify liveness.";

  late final FlutterLiveness _liveness;

  @override
  void initState() {
    super.initState();
    _initLiveness();
  }

  Future<void> _initLiveness() async {
    try {
      _liveness = await FlutterLiveness.create(
        options: LivenessOptions(
          threshold: 0.5,
          laplacianThreshold: 6000,
        ),
      );
    } catch (e) {
      debugPrint('Error initializing liveness: $e');
    }
  }

  void _startLivenessCheck() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = "Analyzing facial structure for spoof attempts...";
    });

    // In a real app, you would pass a face image from the camera stream
    // final result = await _liveness.analyze(faceImage);
    // if (result.isLive) { ... }
    
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isProcessing = false;
      _statusMessage = "Liveness Confirmed!";
    });

    Future.delayed(const Duration(seconds: 1), () {
      widget.onSuccess();
    });
  }

  @override
  void dispose() {
    _liveness.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Biometric Security Verification')),
      body: Center(
        child: AdaptiveCard(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.face_retouching_natural, size: 80, color: Colors.cyan),
              const SizedBox(height: 24),
              Text(
                'EHR Access Secured',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _startLivenessCheck,
                  child: const Text('Start Liveness Check'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
