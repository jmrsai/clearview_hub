import 'package:flutter/material.dart';
import '../../../../ai_engine/quantum/quantum_federated_learning_service.dart';
import '../../../../ai_engine/services/cloud_sync_manager.dart';

class GlobalQuantumNetworkScreen extends StatefulWidget {
  const GlobalQuantumNetworkScreen({super.key});

  @override
  State<GlobalQuantumNetworkScreen> createState() => _GlobalQuantumNetworkScreenState();
}

class _GlobalQuantumNetworkScreenState extends State<GlobalQuantumNetworkScreen> with TickerProviderStateMixin {
  bool _isSyncing = false;
  int _wellnessPoints = 450;
  List<String> _syncLogs = [];
  late AnimationController _globeController;

  @override
  void initState() {
    super.initState();
    _globeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _globeController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _syncLogs.insert(0, "[${DateTime.now().toLocal().toString().split(' ')[1].substring(0, 8)}] $message");
    });
  }

  Future<void> _triggerQuantumSync() async {
    setState(() {
      _isSyncing = true;
      _syncLogs.clear();
    });
    
    _addLog("Initializing Quantum Bot Worker...");
    await Future.delayed(const Duration(seconds: 1));
    
    _addLog("Training local model on new diagnostic data...");
    final pqcPayload = await QuantumFederatedLearningService().trainLocalModelAndExtractWeights();
    
    _addLog("Local training complete. PQC Payload Generated.");
    await Future.delayed(const Duration(seconds: 1));
    
    _addLog("Uploading Quantum Weights to Global Superbrain...");
    await CloudSyncManager().syncQuantumFederatedWeights(pqcPayload);
    await Future.delayed(const Duration(seconds: 1));
    
    _addLog("Upload Successful! Master AI updated.");
    
    setState(() {
      _isSyncing = false;
      _wellnessPoints += 50; // Award points for contributing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        title: const Text('Global Quantum Network', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Global Nodes Active', style: TextStyle(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('1,402,893', style: TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Your Contribution', style: TextStyle(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text('$_wellnessPoints pts', style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Animated Globe / Superbrain visualization
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _globeController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _globeController.value * 2 * 3.14159,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 2),
                            ),
                          ),
                        );
                      },
                    ),
                    Icon(
                      Icons.public,
                      size: 150,
                      color: _isSyncing ? Colors.purpleAccent : Colors.cyan.withValues(alpha: 0.5),
                    ),
                    if (_isSyncing)
                      const CircularProgressIndicator(
                        color: Colors.purpleAccent,
                        strokeWidth: 4,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Federated Learning AI Sync',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Train the global AI directly from your phone. Zero personal data leaves this device. Only encrypted mathematical weights are shared.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const Spacer(),
            // Logs
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: ListView.builder(
                itemCount: _syncLogs.length,
                itemBuilder: (context, index) {
                  return Text(
                    _syncLogs[index],
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 12),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSyncing ? null : _triggerQuantumSync,
              icon: _isSyncing ? const SizedBox.shrink() : const Icon(Icons.sync, color: Colors.black),
              label: _isSyncing 
                  ? const Text('SYNCING TO SUPERBRAIN...', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                  : const Text('INITIATE BOT SYNC', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
