import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../../widgets/glass_card.dart';

class BlinkBlitzGame extends StatefulWidget {
  const BlinkBlitzGame({super.key});

  @override
  State<BlinkBlitzGame> createState() => _BlinkBlitzGameState();
}

class _BlinkBlitzGameState extends State<BlinkBlitzGame> {
  CameraController? _controller;
  bool _isInitialized = false;
  int _blinkCount = 0;
  int _timeLeft = 15;
  bool _isPlaying = false;
  bool _isFinished = false;
  Timer? _timer;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isProcessing = false;
  DateTime? _lastBlinkTime;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  void _startGame() {
    setState(() {
      _blinkCount = 0;
      _timeLeft = 15;
      _isPlaying = true;
      _isFinished = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _stopGame();
      }
    });

    _startImageStream();
  }

  void _startImageStream() {
    _controller?.startImageStream((image) async {
      if (_isProcessing || !_isPlaying) return;
      _isProcessing = true;

      try {
        final inputImage = _processCameraImage(image);
        final faces = await _faceDetector.processImage(inputImage);

        if (faces.isNotEmpty) {
          final face = faces.first;
          if (face.leftEyeOpenProbability != null &&
              face.rightEyeOpenProbability != null) {
            final leftOpen = face.leftEyeOpenProbability! > 0.4;
            final rightOpen = face.rightEyeOpenProbability! > 0.4;

            if (!leftOpen && !rightOpen) {
              // Eyes closed
              _lastBlinkTime = DateTime.now();
            } else if (leftOpen && rightOpen && _lastBlinkTime != null) {
              // Reopened
              setState(() => _blinkCount++);
              _lastBlinkTime = null;
            }
          }
        }
      } catch (e) {
        debugPrint('Blink detection error: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage _processCameraImage(CameraImage image) {
    // This is a simplified version of image conversion for ML Kit
    // In a full implementation, you'd need the rotation and plane data correctly
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final InputImageMetadata metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation:
          InputImageRotation.rotation270deg, // Front camera usually needs 270
      format:
          InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void _stopGame() {
    _timer?.cancel();
    _controller?.stopImageStream();
    setState(() {
      _isPlaying = false;
      _isFinished = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isInitialized) Center(child: CameraPreview(_controller!)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Text(
                          'Time: $_timeLeft',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!_isPlaying && !_isFinished) _buildStartOverlay(),
                  if (_isPlaying) _buildGameOverlay(),
                  if (_isFinished) _buildResultOverlay(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartOverlay() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.flash_on, color: Colors.yellowAccent, size: 64),
          const SizedBox(height: 16),
          const Text(
            'BLINK BLITZ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Blink as many times as you can in 15 seconds to lubricate your eyes!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: const Text('START GAME'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverlay() {
    return Column(
      children: [
        Text(
          '$_blinkCount',
          style: const TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          'BLINKS',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildResultOverlay() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'TIME UP!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You blinked $_blinkCount times!',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          const Text(
            'Great job keeping your eyes moist!',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'EXIT',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
