import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import '../../../../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class AnatomyExplorerScreen extends StatefulWidget {
  final String modelUrl;
  final String partName;

  const AnatomyExplorerScreen({
    super.key, 
    required this.modelUrl, 
    required this.partName
  });

  @override
  State<AnatomyExplorerScreen> createState() => _AnatomyExplorerScreenState();
}

class _AnatomyExplorerScreenState extends State<AnatomyExplorerScreen> {
  final Flutter3DController _controller = Flutter3DController();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.partName} 3D Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showTutorial(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Model Viewer
          Flutter3DViewer(
            controller: _controller,
            src: widget.modelUrl,
            onProgress: (double progress) {
              if (progress == 1.0) setState(() => _isLoading = false);
            },
          ),

          // Loading Overlay
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.secondary)),

          // Control Overlays
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildControls(),
          ),
          
          Positioned(
            top: 20,
            left: 20,
            child: _buildAnatomyInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlIcon(icon: Icons.zoom_in, label: 'Zoom', onTap: () {}),
          _ControlIcon(icon: Icons.rotate_left, label: 'Reset', onTap: () => _controller.reset()),
          _ControlIcon(icon: Icons.layers, label: 'Layers', onTap: () {}),
          _ControlIcon(icon: Icons.info_outline, label: 'Details', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildAnatomyInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.partName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Interactive Medical Model',
            style: TextStyle(fontSize: 12, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    // Show accessibility-focused tutorial on how to use gestures
  }
}

class _ControlIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlIcon({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
