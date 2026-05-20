import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../domain/services/ar_engine.dart';

class ARWellnessScreen extends ConsumerStatefulWidget {
  const ARWellnessScreen({super.key});

  @override
  ConsumerState<ARWellnessScreen> createState() => _ARWellnessScreenState();
}

class _ARWellnessScreenState extends ConsumerState<ARWellnessScreen> {
  CameraController? _controller;
  bool _isBusy = false;
  List<Face> _faces = [];
  ARFilter? _currentFilter;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller?.initialize();
    if (mounted) {
      setState(() {});
      await _controller?.startImageStream(_processCameraImage);
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isBusy) return;
    _isBusy = true;

    final inputImage = _getInputImage(image);
    if (inputImage == null) {
      _isBusy = false;
      return;
    }

    final engine = ref.read(arSystemEngineProvider);
    final faces = await engine.processImage(inputImage);

    if (mounted) {
      setState(() {
        _faces = faces;
      });
    }
    _isBusy = false;
  }

  InputImage? _getInputImage(CameraImage image) {
    // Simplified InputImage conversion for prototype
    // In production, this needs proper plane handling for Android/iOS
    return null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller!),
          _buildAROverlay(),
          _buildFilterSelector(),
          _buildTopBar(),
        ],
      ),
    );
  }

  Widget _buildAROverlay() {
    if (_faces.isEmpty || _currentFilter == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: ARPainter(faces: _faces, filter: _currentFilter!),
      child: Container(),
    );
  }

  Widget _buildFilterSelector() {
    final filters = ref.read(arSystemEngineProvider).getAvailableFilters();
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _currentFilter?.id == filter.id;
          return GestureDetector(
            onTap: () => setState(() => _currentFilter = filter),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.white24,
                  width: 3,
                ),
                color: Colors.black45,
              ),
              child: Center(
                child: Icon(
                  _getIconForFilter(filter.type),
                  color: isSelected ? Colors.blueAccent : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForFilter(ARFilterType type) {
    switch (type) {
      case ARFilterType.glassesTryOn:
        return Icons.remove_red_eye;
      case ARFilterType.relaxationAura:
        return Icons.spa;
      case ARFilterType.focusOverlay:
        return Icons.center_focus_strong;
      case ARFilterType.fatigueSimulator:
        return Icons.face;
    }
    return Icons.help_outline;
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'AR Wellness',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.flip_camera_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ARPainter extends CustomPainter {
  final List<Face> faces;
  final ARFilter filter;

  ARPainter({required this.faces, required this.filter});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blueAccent;

    for (final face in faces) {
      if (filter.type == ARFilterType.glassesTryOn) {
        // Draw virtual glasses around eyes
        final leftEye = face.landmarks[FaceLandmarkType.leftEye];
        final rightEye = face.landmarks[FaceLandmarkType.rightEye];
        if (leftEye != null && rightEye != null) {
          canvas.drawCircle(
            Offset(
              leftEye.position.x.toDouble(),
              leftEye.position.y.toDouble(),
            ),
            20,
            paint,
          );
          canvas.drawCircle(
            Offset(
              rightEye.position.x.toDouble(),
              rightEye.position.y.toDouble(),
            ),
            20,
            paint,
          );
          canvas.drawLine(
            Offset(
              leftEye.position.x.toDouble(),
              leftEye.position.y.toDouble(),
            ),
            Offset(
              rightEye.position.x.toDouble(),
              rightEye.position.y.toDouble(),
            ),
            paint,
          );
        }
      } else if (filter.type == ARFilterType.relaxationAura) {
        // Draw a "halo" or aura around the face
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              face.boundingBox.center.dx,
              face.boundingBox.center.dy,
            ),
            width: face.boundingBox.width * 1.5,
            height: face.boundingBox.height * 1.5,
          ),
          paint
            ..color = Colors.purpleAccent.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ARPainter oldDelegate) => true;
}
