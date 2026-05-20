import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/database/database_service.dart';
import 'core/providers/database_provider.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:clearview_hub/features/vision_safety/presentation/widgets/eye_strain_overlay.dart';
import 'core/security/app_integrity_service.dart';

// New Architecture Imports
import 'encrypted_chat/encrypted_chat_service.dart';
import 'realtime/realtime_sync_engine.dart';
import 'optimization/performance_optimizer.dart';
import 'adaptive_ui/adaptive_ui_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- SECURITY: DEVICE INTEGRITY CHECK ---
  final integrityService = AppIntegrityService();
  final isDeviceSecure = await integrityService.verifyDeviceIntegrity();

  if (!isDeviceSecure) {
    // Fail Securely: Do not initialize Supabase or load local databases
    // if the device is rooted, jailbroken, or running in an emulator.
    runApp(const SecurityBlockedApp());
    return;
  }

  // Initialize Supabase (Clinical Data & Auth)
  await Supabase.initialize(
    url: 'https://pqtpojzebxrysqbjsvmp.supabase.co',
    anonKey: 'sb_publishable_KSNrdVNOtET45vdMpnJvQQ_CRZVvMwB',
  );

  // Initialize Offline DB
  await Hive.initFlutter();

  // Initialize Encrypted Storage and Models
  final dbService = DatabaseService();
  await dbService.init();

  // Initialize New Architecture Engines
  final encryptedChatService = EncryptedChatService();
  await encryptedChatService.init();

  final realtimeSyncEngine = RealtimeSyncEngine();
  await realtimeSyncEngine.init();

  final performanceOptimizer = PerformanceOptimizer();
  await performanceOptimizer.init();

  runApp(
    ProviderScope(
      overrides: [
        databaseServiceProvider.overrideWithValue(dbService),
        encryptedChatServiceProvider.overrideWithValue(encryptedChatService),
        realtimeSyncEngineProvider.overrideWithValue(realtimeSyncEngine),
        performanceOptimizerProvider.overrideWithValue(performanceOptimizer),
      ],
      child: const EyeVerseApp(),
    ),
  );
}

class SecurityBlockedApp extends StatelessWidget {
  const SecurityBlockedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gpp_bad, color: Colors.redAccent, size: 80),
                SizedBox(height: 24),
                Text(
                  'Security Violation Detected',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'EyeVerse AI cannot run on a compromised, rooted, or emulated device to protect sensitive medical data.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EyeVerseApp extends ConsumerWidget {
  const EyeVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);
    final isDyslexiaMode = ref.watch(dyslexiaModeProvider);

    return MaterialApp.router(
      title: 'EyeVerse AI',
      theme: AppTheme.darkTheme, // Light theme can be added later
      darkTheme: isDyslexiaMode ? AppTheme.dyslexiaDarkTheme : AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return EyeStrainOverlay(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
