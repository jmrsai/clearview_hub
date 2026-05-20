import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clearview_hub/shared/widgets/main_scaffold.dart';

// --- FEATURE SCREENS ---
// Auth
import 'package:clearview_hub/features/auth/presentation/screens/login_screen.dart';
import 'package:clearview_hub/features/auth/presentation/screens/register_screen.dart';
import 'package:clearview_hub/features/auth/presentation/providers/auth_provider.dart';

// Dashboard & Patients
import 'package:clearview_hub/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:clearview_hub/features/patients/presentation/screens/patients_dashboard.dart';

// Vision Lab & Diagnostic
import 'package:clearview_hub/features/ai_screening/presentation/screens/disease_detection_screen.dart';
import 'package:clearview_hub/features/vision_tests/presentation/screens/vision_tests_dashboard.dart';
import 'package:clearview_hub/features/vision_tests/presentation/screens/visual_acuity_test_screen.dart';
import 'package:clearview_hub/features/vision_tests/presentation/screens/amsler_grid_test_screen.dart';
import 'package:clearview_hub/features/vision_tests/presentation/screens/color_blindness_test_screen.dart';
import 'package:clearview_hub/features/vision_tests/presentation/screens/astigmatism_test_screen.dart';
import 'package:clearview_hub/features/ai_screening/presentation/screens/ai_scanner_screen.dart';


// Safety & Prevention
import 'package:clearview_hub/features/vision_safety/presentation/screens/eye_scanner_screen.dart';
import 'package:clearview_hub/features/vision_safety/presentation/screens/distance_monitor_screen.dart';

// Telemedicine
import 'package:clearview_hub/features/telemedicine/presentation/screens/doctor_discovery_screen.dart';
import 'package:clearview_hub/features/telemedicine/presentation/screens/booking_screen.dart';
import 'package:clearview_hub/features/telemedicine/domain/entities/doctor.dart';

// Knowledge & Education
import 'package:clearview_hub/features/knowledge_system/presentation/screens/knowledge_hub_screen.dart';
import 'package:clearview_hub/features/knowledge_system/presentation/screens/anatomy_explorer_screen.dart';
import 'package:clearview_hub/features/education/presentation/screens/education_screen.dart';

// Community
import 'package:clearview_hub/features/community/presentation/screens/community_discovery_screen.dart';
import 'package:clearview_hub/features/community/presentation/screens/community_feed_screen.dart';

// Business & Entrepreneur
import 'package:clearview_hub/features/entrepreneur_hub/presentation/screens/entrepreneur_dashboard.dart';

// Analytics & Profile
import 'package:clearview_hub/features/supabase_analytics/presentation/screens/health_analytics_dashboard.dart';
import 'package:clearview_hub/features/profile/presentation/screens/profile_screen.dart';
import 'package:clearview_hub/features/profile/presentation/screens/accessibility_settings_screen.dart';

// Shared & Misc
import 'package:clearview_hub/shared/screens/placeholders.dart' hide SymptomCheckerScreen, EducationScreen, ProfileScreen, AccessibilitySettingsScreen, MainScaffold;
import 'package:clearview_hub/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:clearview_hub/features/motion_wellness/presentation/screens/motion_wellness_screen.dart';
import 'package:clearview_hub/features/digital_wellbeing/presentation/screens/digital_wellbeing_screen.dart';
import 'package:clearview_hub/features/sleep/presentation/screens/sleep_protection_screen.dart';
import 'package:clearview_hub/features/wellness_core/presentation/screens/wellness_training_dashboard.dart';
import 'package:clearview_hub/features/avatars/presentation/screens/leaderboard_screen.dart';
import 'package:clearview_hub/features/encrypted_chat/presentation/screens/encrypted_chat_screen.dart';
import 'package:clearview_hub/features/wellness_bots/presentation/screens/wellness_bot_list_screen.dart';
import 'package:clearview_hub/features/wellness_bots/presentation/screens/wellness_bot_chat_screen.dart';
import 'package:clearview_hub/features/wellness_bots/domain/services/wellness_bot_service.dart' as bot_service;
import 'package:clearview_hub/features/clinic/presentation/screens/clinic_dashboard.dart';
import 'package:clearview_hub/features/clinic/presentation/screens/clinic_registration_screen.dart';
import 'package:clearview_hub/features/clinic/presentation/screens/retina_capture_screen.dart';
import 'package:clearview_hub/features/games/presentation/screens/games_dashboard_screen.dart';
import 'package:clearview_hub/features/games/presentation/screens/blink_blitz_game_screen.dart';
import 'package:clearview_hub/features/games/presentation/screens/focus_pro_game_screen.dart';
import 'package:clearview_hub/features/games/presentation/screens/multi_age_games_dashboard.dart';
import 'package:clearview_hub/features/reels/presentation/screens/wellness_reels_screen.dart';
import 'package:clearview_hub/features/wellness_groups/presentation/screens/wellness_group_discovery_screen.dart';
import 'package:clearview_hub/features/video_system/presentation/screens/wellness_video_explorer_screen.dart';
import 'package:clearview_hub/features/creator_platform/presentation/screens/creator_dashboard_screen.dart';
import 'package:clearview_hub/features/creator_tools/presentation/screens/creator_tool_screen.dart';
import 'package:clearview_hub/features/medications/presentation/screens/medication_scheduler_screen.dart';
import 'package:clearview_hub/features/symptom_checker/presentation/screens/symptom_checker_screen.dart';
import 'package:clearview_hub/features/supabase_test/presentation/screens/supabase_test_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final isAuth = ref.watch(authStateProvider).value != null;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final loggingIn = state.uri.path == '/login' || state.uri.path == '/register';
      final onboarding = state.uri.path == '/splash' || state.uri.path == '/onboarding';

      if (!isAuth && !loggingIn && !onboarding) return '/login';
      if (isAuth && (loggingIn || onboarding)) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'patients',
                name: 'patients',
                builder: (context, state) => const PatientsDashboard(),
              ),
              GoRoute(
                path: 'disease_detection',
                name: 'disease_detection',
                builder: (context, state) => const DiseaseDetectionScreen(),
              ),
              GoRoute(
                path: 'symptom_checker',
                name: 'symptom_checker',
                builder: (context, state) => const SymptomCheckerScreen(),
              ),
              GoRoute(
                path: 'telemedicine',
                name: 'telemedicine',
                builder: (context, state) => const DoctorDiscoveryScreen(),
                routes: [
                  GoRoute(
                    path: 'book',
                    name: 'book_appointment',
                    builder: (context, state) {
                      final doctor = state.extra as Doctor;
                      return BookingScreen(doctor: doctor);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'eye_scanner',
                name: 'eye_scanner',
                builder: (context, state) => const EyeScannerScreen(),
                routes: [
                  GoRoute(
                    path: 'scan',
                    name: 'eye_scan_camera',
                    builder: (context, state) {
                      final scanType = state.extra as String? ?? 'General';
                      return AIEyeScannerScreen(scanType: scanType);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'distance_monitor',
                name: 'distance_monitor',
                builder: (context, state) => const DistanceMonitorScreen(),
              ),
              GoRoute(
                path: 'analytics',
                name: 'analytics',
                builder: (context, state) => const HealthAnalyticsDashboard(),
              ),
              GoRoute(
                path: 'ai_assistant',
                name: 'ai_assistant',
                builder: (context, state) => const AiAssistantScreen(),
              ),
              GoRoute(
                path: 'motion_wellness',
                name: 'motion_wellness',
                builder: (context, state) => const MotionWellnessScreen(),
              ),
              GoRoute(
                path: 'digital_wellbeing',
                name: 'digital_wellbeing',
                builder: (context, state) => const DigitalWellbeingScreen(),
              ),
              GoRoute(
                path: 'sleep_protection',
                name: 'sleep_protection',
                builder: (context, state) => const SleepProtectionScreen(),
              ),
              GoRoute(
                path: 'wellness_training',
                name: 'wellness_training',
                builder: (context, state) => const WellnessTrainingDashboard(),
              ),
              GoRoute(
                path: 'leaderboard',
                name: 'leaderboard',
                builder: (context, state) => const LeaderboardScreen(),
              ),
              GoRoute(
                path: 'chat',
                name: 'chat',
                builder: (context, state) => const EncryptedChatScreen(
                  peerName: 'Dr. Sarah',
                  peerAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah',
                ),
              ),
              GoRoute(
                path: 'wellness_bots',
                name: 'wellness_bots',
                builder: (context, state) => const WellnessBotListScreen(),
                routes: [
                  GoRoute(
                    path: 'chat',
                    name: 'bot_chat',
                    builder: (context, state) {
                      final bot = state.extra as bot_service.WellnessBot;
                      return WellnessBotChatScreen(bot: bot);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'clinic',
                name: 'clinic',
                builder: (context, state) => const ClinicDashboard(),
                routes: [
                  GoRoute(
                    path: 'registration',
                    name: 'clinic_registration',
                    builder: (context, state) => const ClinicRegistrationScreen(),
                  ),
                  GoRoute(
                    path: 'retina_capture',
                    name: 'retina_capture',
                    builder: (context, state) => const RetinaCaptureScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'entrepreneur',
                name: 'entrepreneur',
                builder: (context, state) => const EntrepreneurDashboard(),
              ),
            ],
          ),

          GoRoute(
            path: '/vision_lab',
            name: 'vision_lab',
            builder: (context, state) => const VisionTestsDashboard(),
            routes: [
              GoRoute(
                path: 'acuity',
                name: 'acuity',
                builder: (context, state) => const VisualAcuityTestScreen(),
              ),
              GoRoute(
                path: 'amsler_grid',
                name: 'amsler_grid',
                builder: (context, state) => const AmslerGridTestScreen(),
              ),
              GoRoute(
                path: 'color_blindness',
                name: 'color_blindness',
                builder: (context, state) => const ColorBlindnessTestScreen(),
              ),
              GoRoute(
                path: 'astigmatism',
                name: 'astigmatism',
                builder: (context, state) => const AstigmatismTestScreen(),
              ),
              GoRoute(
                path: 'therapy',
                name: 'therapy',
                builder: (context, state) => const TherapyScreen(),
              ),
              GoRoute(
                path: 'anatomy',
                name: 'anatomy_explorer',
                builder: (context, state) {
                  final extra = state.extra as Map<String, String>;
                  return AnatomyExplorerScreen(
                    modelUrl: extra['url']!,
                    partName: extra['name']!,
                  );
                },
              ),
              GoRoute(
                path: 'games',
                name: 'games',
                builder: (context, state) => const GamesDashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'blink_blitz',
                    name: 'blink_blitz',
                    builder: (context, state) => const BlinkBlitzGame(),
                  ),
                  GoRoute(
                    path: 'focus_pro',
                    name: 'focus_pro',
                    builder: (context, state) => const FocusProGame(),
                  ),
                  GoRoute(
                    path: 'multi_age',
                    name: 'multi_age_games',
                    builder: (context, state) => const MultiAgeGamesDashboard(),
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityDiscoveryScreen(),
            routes: [
              GoRoute(
                path: 'feed/:id',
                name: 'community_feed',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final name = state.extra as String? ?? 'Community';
                  return CommunityFeedScreen(communityId: id, communityName: name);
                },
              ),
              GoRoute(
                path: 'education',
                name: 'education',
                builder: (context, state) => const EducationScreen(),
              ),
              GoRoute(
                path: 'knowledge_hub',
                name: 'knowledge_hub',
                builder: (context, state) => const KnowledgeHubScreen(),
              ),
              GoRoute(
                path: 'videos',
                name: 'wellness_videos',
                builder: (context, state) => const WellnessVideoExplorerScreen(),
              ),
            ],
          ),

          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: 'accessibility',
                name: 'accessibility',
                builder: (context, state) => const AccessibilitySettingsScreen(),
              ),
              GoRoute(
                path: 'medications',
                name: 'medications',
                builder: (context, state) => MedicationSchedulerScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
