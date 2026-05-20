import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clearview_hub/core/theme/app_colors.dart';

class TeleophthalmologyCallScreen extends StatefulWidget {
  final String doctorName;

  const TeleophthalmologyCallScreen({super.key, required this.doctorName});

  @override
  State<TeleophthalmologyCallScreen> createState() => _TeleophthalmologyCallScreenState();
}

class _TeleophthalmologyCallScreenState extends State<TeleophthalmologyCallScreen> {
  CameraController? _controller;
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isScreenSharing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: true);
    await _controller!.initialize();
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _endCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote Video Stream (Placeholder: Doctor image or Screen Share)
            Positioned.fill(
              child: _isScreenSharing
                  ? _buildScreenShareView()
                  : Image.network(
                      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=800&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
            ),
            
            // Gradient overlay for better UI visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Top Info Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  const Icon(Icons.security, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  const Text('End-to-End Encrypted', style: TextStyle(color: Colors.green, fontSize: 12)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('12:45', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Doctor Info
            Positioned(
              top: 60,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Retina Specialist',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Local Video Stream (PIP)
            Positioned(
              top: 60,
              right: 16,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                  color: Colors.black54,
                ),
                clipBehavior: Clip.antiAlias,
                child: _isVideoOff || _controller == null || !_controller!.value.isInitialized
                    ? const Center(child: Icon(Icons.videocam_off, color: Colors.white54))
                    : CameraPreview(_controller!),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    color: _isMuted ? Colors.white24 : Colors.white,
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _buildControlButton(
                    icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                    color: _isVideoOff ? Colors.white24 : Colors.white,
                    onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                  ),
                  _buildControlButton(
                    icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
                    color: _isScreenSharing ? AppColors.primary : Colors.white,
                    onPressed: () => setState(() => _isScreenSharing = !_isScreenSharing),
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    color: Colors.white,
                    backgroundColor: Colors.redAccent,
                    onPressed: _endCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenShareView() {
    return Container(
      color: Colors.blueGrey.shade900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.remove_red_eye, size: 100, color: Colors.cyan),
            const SizedBox(height: 16),
            const Text(
              'Doctor is sharing an OCT Scan',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'High-Fidelity WebRTC Stream Active',
              style: TextStyle(color: Colors.cyan.withValues(alpha: 0.8), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    Color backgroundColor = Colors.white10,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
