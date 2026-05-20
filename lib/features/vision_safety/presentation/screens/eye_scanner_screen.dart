import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/glass_card.dart';

class EyeScannerScreen extends StatelessWidget {
  const EyeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Eye Scanner'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F3460), Color(0xFF0A0E1A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comprehensive Eye Analysis',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan for redness, cataracts, and dry eye using advanced AI.',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildScanOption(
                        context,
                        'Redness Detect',
                        Icons.visibility,
                        Colors.redAccent,
                      ),
                      _buildScanOption(
                        context,
                        'Cataract Scan',
                        Icons.remove_red_eye,
                        Colors.blueAccent,
                      ),
                      _buildScanOption(
                        context,
                        'Dry Eye Check',
                        Icons.water_drop,
                        Colors.cyanAccent,
                      ),
                      _buildScanOption(
                        context,
                        'Swelling Check',
                        Icons.face,
                        Colors.orangeAccent,
                      ),
                    ],
                  ),
                ),
                const GlassCard(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Medical Disclaimer',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'AI results are for awareness only and are not a medical diagnosis. Please consult a certified eye specialist.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.pushNamed('eye_scan_camera', extra: title);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
