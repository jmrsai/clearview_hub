/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/database/database_helper.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/biometric_auth_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'core/services/ehr_sync_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/translator_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/wellness_service.dart';
import 'core/services/gemini_service.dart';
import 'core/services/global_error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Step 1: Load environment variables (API keys, config) ──────────────────
  // MUST be first so all services can access config via AppConfig.*
  await AppConfig.initialize();

  // ── Step 2: System UI configuration ───────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0E1A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // ── Initialize Auto-Healing Service ───────────────────────────────────────
  GlobalErrorHandler().initialize();

  // ── Step 3: Firebase initialization ───────────────────────────────────────
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Route all uncaught Flutter framework errors → Crashlytics
    final originalFlutterError = FlutterError.onError;
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      if (originalFlutterError != null) originalFlutterError(errorDetails);
    };

    // Route all uncaught async errors → Crashlytics
    final originalPlatformError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      if (originalPlatformError != null) {
        return originalPlatformError(error, stack);
      }
      return true;
    };

    // Advanced Firebase services (Push, Remote Config, Analytics)
    await FirebaseService.instance.init();

    // App Check — prevents unauthorized API use
    // Use debug provider in debug mode, play integrity in release
    await FirebaseAppCheck.instance.activate(
      // ignore: deprecated_member_use
      androidProvider: AndroidProvider.debug,
      // ignore: deprecated_member_use
      appleProvider: AppleProvider.debug,
    );

    // Language preference
    await TranslatorService.instance.initialize();
  } catch (e) {
    debugPrint('[main] Firebase initialization error: $e');
  }

  // ── Step 4: Local services ─────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final themeService = ThemeService(prefs);

  // Initialize encrypted local database
  await DatabaseHelper.instance.database;

  // Authentication session
  await AuthService.instance.init();

  // Connectivity monitoring (offline-first)
  await ConnectivityService.instance.initialize();

  // Digital eye wellness tracking
  await WellnessService.instance.initialize();

  // Initialize AI service (non-blocking — gracefully disabled if no key)
  GeminiService.instance.initialize();

  // Background EHR sync
  EhrSyncService.instance.start();

  runApp(ClearViewApp(themeService: themeService));
}

class ClearViewApp extends StatelessWidget {
  final ThemeService themeService;

  const ClearViewApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13/14/15 Pro standard
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: Listenable.merge([AuthService.instance, themeService]),
          builder: (context, _) {
            return MaterialApp(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeService.themeMode,
              initialRoute: AuthService.instance.isAuthenticated ? '/auth' : '/login',
              routes: {
                '/login': (_) => const LoginScreen(),
                '/auth':  (_) => const BiometricAuthScreen(),
                '/home':  (_) => const DashboardScreen(),
              },
            );
          },
        );
      },
    );
  }
}
