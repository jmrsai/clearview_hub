import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../../ai_engine/services/oct_report_analyzer_service.dart';

class RetinaCaptureScreen extends StatefulWidget {
  const RetinaCaptureScreen({super.key});

  @override
  State<RetinaCaptureScreen> createState() => _RetinaCaptureScreenState();
}

class _RetinaCaptureScreenState extends State<RetinaCaptureScreen> {
  CameraController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final rearCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      rearCamera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Center(child: CameraPreview(_controller!)),

          // Overlay - Retina Alignment Circle
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.cyan.withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.cyan, size: 40),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Align the eye within the circle and ensure the pupil is centered. Use flashlight if necessary.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () => _controller!.setFlashMode(FlashMode.torch),
                ),
                GestureDetector(
                  onTap: () async {
                    final image = await _controller!.takePicture();
                    // TODO: Pass image to AI disease engine
                    _showCapturedImage(image);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isAnalyzing = false;
  OctAnalysisReport? _report;

  void _showCapturedImage(XFile image) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0E1A),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  _report == null ? 'Capture Preview' : 'Diagnostic Report',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (_report == null)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (_report != null)
                  Expanded(
                    child: ListView(
                      children: [
                        _buildStatCard('Diabetic Retinopathy', '${(_report!.diabeticRetinopathyConfidence * 100).toStringAsFixed(1)}%'),
                        _buildStatCard('Glaucoma Risk', '${(_report!.glaucomaRisk * 100).toStringAsFixed(1)}%'),
                        _buildStatCard('Macular Degeneration', '${(_report!.macularDegenerationRisk * 100).toStringAsFixed(1)}%'),
                        const SizedBox(height: 16),
                        const Text('Detailed Pathology', style: TextStyle(color: Colors.cyan, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(_report!.detailedPathology, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          child: Text(
                            'Urgency: ${_report!.urgencyLevel}',
                            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                if (_report == null)
                  ElevatedButton(
                    onPressed: _isAnalyzing
                        ? null
                        : () async {
                            setModalState(() => _isAnalyzing = true);
                            try {
                              final analyzer = OctReportAnalyzerService();
                              final report = await analyzer.analyzeRetinaScanCloud(File(image.path));
                              setModalState(() {
                                _report = report;
                                _isAnalyzing = false;
                              });
                            } catch (e) {
                              setModalState(() => _isAnalyzing = false);
                              debugPrint("Error: $e");
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isAnalyzing
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('RUN HEAVY CLOUD AI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                if (_report != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close modal
                      Navigator.pop(context); // Close camera
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Consult Doctor / Exit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(value, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
