import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class ColorIdentifierScreen extends StatefulWidget {
  const ColorIdentifierScreen({super.key});

  @override
  State<ColorIdentifierScreen> createState() => _ColorIdentifierScreenState();
}

class _ColorIdentifierScreenState extends State<ColorIdentifierScreen> {
  CameraController? _controller;
  String _detectedColor = "Scanning...";

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final firstCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(firstCamera, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    
    // Simulating color detection logic (in a real app, this parses startImageStream pixels)
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _scanColor() {
    setState(() {
      _detectedColor = "Analyzing...";
    });
    // Simulate a network or ML call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final colors = ["Deep Red", "Navy Blue", "Forest Green", "Bright Yellow", "Charcoal Gray", "Pure White"];
      colors.shuffle();
      setState(() {
        _detectedColor = colors.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(_controller!),
            ),
            
            // Top Bar
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Center Target Crosshair
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.add, color: AppColors.primary, size: 24),
                ),
              ),
            ),

            // Bottom Results & Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Detected Color',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _detectedColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _scanColor,
                        icon: const Icon(Icons.color_lens),
                        label: const Text('Identify Center Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
