import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../../ai_engine/services/eye_surface_analyzer_service.dart';

class SurfaceEyeScanScreen extends StatefulWidget {
  const SurfaceEyeScanScreen({super.key});

  @override
  State<SurfaceEyeScanScreen> createState() => _SurfaceEyeScanScreenState();
}

class _SurfaceEyeScanScreenState extends State<SurfaceEyeScanScreen> {
  CameraController? _cameraController;
  bool _isAnalyzing = false;
  EyeSurfaceAnalysisResult? _result;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Use the front camera for self-scanning
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final analyzer = EyeSurfaceAnalyzerService();
      final result = await analyzer.analyzeSurfaceImage(image);

      setState(() {
        _result = result;
      });
    } catch (e) {
      debugPrint("Analysis error: $e");
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Surface AI Scan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          
          // Targeting Overlay
          if (_result == null)
            Center(
              child: Container(
                width: 250,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.8), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Align eyes here', style: TextStyle(color: Colors.cyanAccent)),
                  ),
                ),
              ),
            ),

          // Analysis Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.cyanAccent),
                    SizedBox(height: 16),
                    Text('AI Analyzing Redness & Infection...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

          // Results Overlay
          if (_result != null && !_isAnalyzing)
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      Row(
                        children: [
                          Icon(
                            _result!.requiresHospital ? Icons.local_hospital : Icons.health_and_safety,
                            color: _result!.requiresHospital ? Colors.redAccent : Colors.greenAccent,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _result!.primarySymptom,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Home Remedies', style: TextStyle(fontSize: 18, color: Colors.cyanAccent)),
                      const SizedBox(height: 8),
                      ..._result!.homeRemedies.map((remedy) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
                                Expanded(child: Text(remedy, style: const TextStyle(color: Colors.white70, fontSize: 14))),
                              ],
                            ),
                          )),
                      const SizedBox(height: 24),
                      if (_result!.requiresHospital) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('DOCTOR RECOMMENDATION', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(_result!.recommendation, style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  // Navigate to Telemedicine
                                },
                                icon: const Icon(Icons.video_call),
                                label: const Text('Consult Doctor Now'),
                              ),
                            ],
                          ),
                        )
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                        onPressed: () {
                          setState(() {
                            _result = null;
                          });
                        },
                        child: const Text('Scan Again', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: _result == null && !_isAnalyzing
          ? FloatingActionButton(
              onPressed: _captureAndAnalyze,
              backgroundColor: Colors.cyanAccent,
              child: const Icon(Icons.camera_alt, color: Colors.black),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
