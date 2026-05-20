import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class MagnifierScreen extends StatefulWidget {
  const MagnifierScreen({super.key});

  @override
  State<MagnifierScreen> createState() => _MagnifierScreenState();
}

class _MagnifierScreenState extends State<MagnifierScreen> {
  CameraController? _controller;
  double _zoomLevel = 1.0;
  double _maxZoom = 1.0;
  double _minZoom = 1.0;
  bool _isFlashOn = false;
  bool _isHighContrast = false;

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

    _controller = CameraController(firstCamera, ResolutionPreset.max, enableAudio: false);
    await _controller!.initialize();
    
    _maxZoom = await _controller!.getMaxZoomLevel();
    _minZoom = await _controller!.getMinZoomLevel();
    _zoomLevel = _minZoom;
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    if (_controller == null) return;
    _isFlashOn = !_isFlashOn;
    await _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
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
            // Camera Preview with optional contrast filter
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: _isHighContrast 
                    ? const ColorFilter.matrix([
                        // High contrast black & white matrix
                        1.5, 1.5, 1.5, 0, -100,
                        1.5, 1.5, 1.5, 0, -100,
                        1.5, 1.5, 1.5, 0, -100,
                        0, 0, 0, 1, 0,
                      ])
                    : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                child: CameraPreview(_controller!),
              ),
            ),
            
            // Top Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _isHighContrast ? AppColors.primary : Colors.black54,
                        child: IconButton(
                          icon: Icon(Icons.contrast, color: _isHighContrast ? Colors.black : Colors.white),
                          onPressed: () => setState(() => _isHighContrast = !_isHighContrast),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: _isFlashOn ? AppColors.primary : Colors.black54,
                        child: IconButton(
                          icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: _isFlashOn ? Colors.black : Colors.white),
                          onPressed: _toggleFlash,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Controls (Zoom)
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_out, color: Colors.white),
                    Expanded(
                      child: Slider(
                        value: _zoomLevel,
                        min: _minZoom,
                        max: _maxZoom.clamp(1.0, 8.0), // Limit to 8x for clarity
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.white24,
                        onChanged: (value) {
                          setState(() => _zoomLevel = value);
                          _controller!.setZoomLevel(value);
                        },
                      ),
                    ),
                    const Icon(Icons.zoom_in, color: Colors.white),
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
