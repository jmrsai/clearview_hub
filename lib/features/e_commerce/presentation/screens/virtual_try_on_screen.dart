import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class VirtualTryOnScreen extends StatefulWidget {
  const VirtualTryOnScreen({super.key});

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  CameraController? _controller;
  int _selectedFrameIndex = 0;

  final List<Map<String, dynamic>> _frames = [
    {'name': 'Classic Aviator', 'color': Colors.amber, 'shape': 'Aviator'},
    {'name': 'Nerd Thick Frame', 'color': Colors.black, 'shape': 'Square'},
    {'name': 'Retro Round', 'color': Colors.brown, 'shape': 'Round'},
    {'name': 'Modern Clear', 'color': Colors.white54, 'shape': 'Wayfarer'},
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use front camera for try-on
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          // Full screen camera
          Positioned.fill(
            child: Transform.scale(
              scale: 1.0, // Scale adjustment for aspect ratio if needed
              child: Center(
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          
          // Simulated AR Overlay (Glasses)
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 80), // Offset slightly up for typical face position
              width: 250,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassLens(_frames[_selectedFrameIndex]['color'], _frames[_selectedFrameIndex]['shape']),
                  Container(
                    width: 30,
                    height: 4,
                    color: _frames[_selectedFrameIndex]['color'],
                  ),
                  _buildGlassLens(_frames[_selectedFrameIndex]['color'], _frames[_selectedFrameIndex]['shape']),
                ],
              ),
            ),
          ),

          // Top App Bar Area
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('AR Try-On', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ],
            ),
          ),

          // Bottom Frame Selector
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'AI Recommended Frames',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _frames.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedFrameIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFrameIndex = index),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 16, bottom: 24),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.white10,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_red_eye, color: _frames[index]['color'], size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  _frames[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassLens(Color color, String shape) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black26, // Lens tint
        borderRadius: shape == 'Round' 
            ? BorderRadius.circular(50) 
            : BorderRadius.circular(12),
        border: Border.all(color: color, width: 6),
      ),
    );
  }
}
