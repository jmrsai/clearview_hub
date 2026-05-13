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
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../models/patient.dart';
import '../patients/patient_list_screen.dart';
import '../health_tracking/medication_log_screen.dart';
import '../health_tracking/vision_progress_screen.dart';
import '../alerts/proximity_alert_service.dart';
import '../alerts/vision_break_service.dart';
import '../alerts/vision_break_overlay.dart';
import '../auth/login_screen.dart';
import '../../core/services/auth_service.dart';
import '../education/vision_simulator_screen.dart';
import '../../core/services/clinic_locator_service.dart';
import '../vision_tests/vision_tests_hub.dart';
import '../therapy/eye_therapy_hub.dart';
import '../diagnostics/symptom_checker_screen.dart';
import '../education/medi_wiki_screen.dart';
import '../general_health/ai_health_chatbot_screen.dart';
import '../ai_assistant/gemini_chat_screen.dart';
import '../medications/medication_reminder_screen.dart';
import '../medications/prescription_scanner_screen.dart';
import '../surgery/surgery_info_hub.dart';
import '../../core/services/translator_service.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/medication_reminder_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/config/app_config.dart';
import '../settings/api_key_setup_screen.dart';
import '../ai_screening/retinal_screening_screen.dart';
import '../ai_screening/medical_document_scanner.dart';
import '../ai_screening/opthas_ai_dashboard.dart';
import '../telemedicine/telemedicine_hub.dart';
import '../pediatric/pediatric_hub.dart';
import '../accessibility/elderly_mode_screen.dart';
import '../wellness/digital_wellness_dashboard.dart';
import '../education/who_standards_screen.dart';
import '../doctor/doctor_dashboard.dart';
import '../patient/patient_dashboard.dart';
import '../education/home_remedies_screen.dart';
import '../games/target_acquisition_game.dart';
import '../../widgets/eye_calibration_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../education/eye_anatomy_3d_viewer.dart';
import '../auth/liveness_verification_screen.dart';
import '../iot/ble_device_scanner.dart';
import '../vision_tests/snellen_chart_screen.dart';
import '../vision_tests/color_blindness_screen.dart';
import '../therapy/amblyopia_therapy_game.dart';
import '../vision_tests/amsler_grid_screen.dart';
import '../vision_tests/advanced_diagnostics_screen.dart';
import '../../core/services/opthas_network_sync_service.dart';
import '../../core/services/ai_vision_insights_service.dart';
import '../../widgets/diagnostic_trend_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/vision_test_result.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  List<Patient> _patients = [];
  int _testsDone = 0;
  int _medsDue = 0;
  bool _loading = true;
  String _aiSummary = 'Analyzing diagnostic data...';
  List<VisionTestResult> _recentTests = [];
  bool _aiLoading = true;
  StreamSubscription? _visionBreakSub;
  final OpthasNetworkSyncService _syncService = OpthasNetworkSyncService();

  @override
  void initState() {
    super.initState();
    _loadData();
    GeminiService.instance.initialize();
    MedicationReminderService.instance.initialize();
    MedicationReminderService.instance.scheduleAllActiveReminders();
    VisionBreakService.instance.initialize();
    _visionBreakSub = VisionBreakService.instance.onBreakTriggered.listen((_) {
      if (mounted) showVisionBreak(context);
    });
    _syncService.addListener(_onSyncUpdate);
  }

  @override
  void dispose() {
    _visionBreakSub?.cancel();
    _syncService.removeListener(_onSyncUpdate);
    super.dispose();
  }

  void _onSyncUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final patients = await db.getAllPatients();
    int tests = 0;
    int medsDue = 0;
    for (final p in patients) {
      final t = await db.getVisionTestsForPatient(p.id);
      tests += t.length;
      final m = await db.getMedicationLogsForPatient(p.id);
      medsDue += m.where((l) => l.status == 'pending').length;
    }
    if (mounted) {
      setState(() {
        _patients = patients;
        _testsDone = tests;
        _medsDue = medsDue;
        _loading = false;
      });
      if (_patients.isNotEmpty) {
        _loadAiInsights();
      }
    }
  }

  Future<void> _loadAiInsights() async {
    final patientId = _patients.first.id;
    final tests = await DatabaseHelper.instance.getVisionTestsForPatient(patientId);
    final summary = await AiVisionInsightsService.instance.generateSummary(patientId);
    if (mounted) {
      setState(() {
        _aiSummary = summary;
        _recentTests = tests;
        _aiLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = AuthService.instance.userRole;

    if (role == 'doctor') {
      return const DoctorDashboard();
    } else if (role == 'patient') {
      return const PatientDashboard();
    }

    // Default or Fallback (Legacy Admin/General)
    return ProximityAlertOverlay(
      child: AdaptiveScaffold(
        body: _loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/loading.png', height: 120),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(color: AppColors.cyan),
                  ],
                ),
              )
            : _navIndex == 0
                ? Skeletonizer(enabled: _loading, child: _homeTab())
                : _navIndex == 1
                    ? PatientListScreen(onChanged: _loadData)
                    : _navIndex == 2
                        ? _patients.isNotEmpty 
                            ? MedicationLogScreen(patientId: _patients.first.id)
                            : _emptyMedicationState()
                        : _settingsTab(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
            BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medications'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _homeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Good ${_greeting()},',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      children: [
                        Image.asset('assets/images/logo.png', height: 32),
                        const SizedBox(width: 12),
                        Text('OpthaS AI',
                            style: Theme.of(context).textTheme.displayLarge),
                      ],
                    ),
                  ])),
              _buildNetworkIndicator(),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 22),
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // Stats row
            Row(children: [
              _StatCard(
                  value: '${_patients.length}',
                  label: 'Patients',
                  icon: Icons.people,
                  color: AppColors.cyan),
              const SizedBox(width: 12),
              _StatCard(
                  value: '$_testsDone',
                  label: 'Tests Done',
                  icon: Icons.visibility,
                  color: AppColors.violet),
              const SizedBox(width: 12),
              _StatCard(
                  value: '$_medsDue',
                  label: 'Meds Due',
                  icon: Icons.medication,
                  color: _medsDue > 0 ? AppColors.warning : AppColors.success),
            ]),
            const SizedBox(height: 24),
            
            // AI Health Insights
            if (_patients.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.cyan, size: 20),
                    const SizedBox(width: 8),
                    Text('AI Health Insights', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Skeletonizer(
                enabled: _aiLoading,
                child: AdaptiveCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _aiSummary,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: _aiLoading ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                      if (!_aiLoading) ...[
                        const SizedBox(height: 16),
                        DiagnosticTrendWidget(results: _recentTests),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Quick actions
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _QuickAction(
                  icon: FontAwesomeIcons.crosshairs,
                  label: 'Eye Calibration',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF005C97), Color(0xFF36D1DC)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EyeCalibrationScreen(
                              onCalibrationComplete: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Calibration Complete!')));
                              }))),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.gamepad,
                  label: 'Therapy Game',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TargetAcquisitionGameWidget())),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.eye,
                  label: 'Vision Tests',
                  gradient: AppColors.primaryGradient,
                  onTap: _patients.isNotEmpty
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  VisionTestsHub(patientId: _patients.first.id)))
                      : () => _noPatientSnack(),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.dumbbell,
                  label: 'Eye Therapy',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  onTap: _patients.isNotEmpty
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  EyeTherapyHub(patientId: _patients.first.id)))
                      : () => _noPatientSnack(),
                ),
                _QuickAction(
                  icon: Icons.person_add,
                  label: 'Add Patient',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  onTap: () => setState(() => _navIndex = 1),
                ),
                _QuickAction(
                  icon: Icons.bar_chart,
                  label: 'Progress',
                  gradient: AppColors.successGradient,
                  onTap: _patients.isNotEmpty
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VisionProgressScreen(
                                  patientId: _patients.first.id)))
                      : () => _noPatientSnack(),
                ),
                _QuickAction(
                  icon: Icons.remove_red_eye,
                  label: 'Vision Sim',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VisionSimulatorScreen())),
                ),
                _QuickAction(
                  icon: Icons.map,
                  label: 'Find Clinics',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)]),
                  onTap: () => ClinicLocatorService.instance.findNearbyClinics(),
                ),
                _QuickAction(
                  icon: Icons.healing,
                  label: 'Symptoms',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SymptomCheckerScreen())),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.bookMedical,
                  label: 'Medi Wiki',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4338CA)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MediWikiScreen())),
                ),
                _QuickAction(
                  icon: Icons.smart_toy,
                  label: 'AI Chat',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFBE185D)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AiHealthChatbot())),
                ),
                _QuickAction(
                  icon: Icons.medical_services,
                  label: 'MedAssist AI',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF2563EB)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const GeminiChatScreen())),
                ),
                _QuickAction(
                  icon: Icons.alarm,
                  label: 'Med Reminders',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF065F46)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MedicationReminderScreen())),
                ),
                _QuickAction(
                  icon: Icons.document_scanner,
                  label: 'Scan Rx',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PrescriptionScannerScreen())),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.hospital,
                  label: 'Surgery Guide',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFF7C3AED)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SurgeryInfoHub())),
                ),
                _QuickAction(
                  icon: Icons.document_scanner_outlined,
                  label: 'Scan Records',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF4F46E5)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MedicalDocumentScanner())),
                ),
                // ── New Global Vision Hub actions ──────────────────────────
                _QuickAction(
                  icon: Icons.graphic_eq,
                  label: 'OpthaS AI',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OpthaSAIDashboard())),
                ),
                _QuickAction(
                  icon: Icons.camera_enhance,
                  label: 'AI Eye Scan',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RetinalScreeningScreen())),
                ),
                _QuickAction(
                  icon: Icons.video_call,
                  label: 'Telemedicine',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TelemedicineHub())),
                ),
                _QuickAction(
                  icon: Icons.child_care,
                  label: "Kids' Zone",
                  gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFF59E0B)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PediatricHub())),
                ),
                _QuickAction(
                  icon: Icons.monitor_heart,
                  label: 'Eye Wellness',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF0EA5E9)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DigitalWellnessDashboard())),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.cubes,
                  label: '3D Eye Anatomy',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EyeAnatomy3DViewer())),
                ),
                _QuickAction(
                  icon: FontAwesomeIcons.fingerprint,
                  label: 'Secure EHR',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFEF4444)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LivenessVerificationScreen(
                                onSuccess: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Access Granted: Liveness Verified')));
                                },
                                onFailure: () {},
                              ))),
                ),
                _QuickAction(
                  icon: Icons.bluetooth_connected,
                  label: 'Medical IoT',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BleDeviceScannerScreen())),
                ),
                _QuickAction(
                  icon: Icons.text_format,
                  label: 'Snellen Test',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFF59E0B)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SnellenChartScreen(
                              patientId: _patients.isNotEmpty
                                  ? _patients.first.id
                                  : (AuthService.instance.userId ?? 'user_1')))),
                ),
                _QuickAction(
                  icon: Icons.palette,
                  label: 'Color Vision',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF34D399)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ColorBlindnessScreen(
                                patientId: _patients.isNotEmpty
                                    ? _patients.first.id
                                    : (AuthService.instance.userId ?? 'user_1')))),
                ),
                _QuickAction(
                  icon: Icons.games,
                  label: 'Amblyopia Rx',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFFC084FC)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AmblyopiaTherapyGame())),
                ),
                _QuickAction(
                  icon: Icons.grid_on,
                  label: 'Amsler Grid',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AmslerGridScreen(
                              patientId: _patients.isNotEmpty
                                  ? _patients.first.id
                                  : (AuthService.instance.userId ?? 'user_1')))),
                ),
                _QuickAction(
                  icon: Icons.health_and_safety,
                  label: 'Home Remedies',
                  gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF047857)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomeRemediesScreen())),
                ),
                _QuickAction(
                  icon: Icons.biotech,
                  label: 'Adv Diagnostics',
                  gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFB45309)]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdvancedDiagnosticsScreen())),
                ),
                ],
                ),
            const SizedBox(height: 24),

            // Recent patients
            if (_patients.isNotEmpty) ...[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Recent Patients',
                      style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(height: 14),
              ..._patients.take(3).map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AdaptiveCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.cyanDim,
                          child: Text(p.initials,
                              style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(p.name,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text('ID: ${p.id} · Age: ${p.age} · ${p.gender}',
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ])),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: AppColors.textHint),
                      ]),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyMedicationState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medication_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No Medications Found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Please add a patient and their medications first.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _navIndex = 1),
            child: const Text('Add Patient'),
          ),
        ],
      ),
    );
  }

  Widget _settingsTab() {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Settings', style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 20),
      AdaptiveCard(child: Column(children: [
        ListTile(
          leading: const Icon(Icons.translate, color: AppColors.cyan),
          title: const Text('Language'),
          subtitle: Text('${TranslatorService.instance.currentLanguageName} — Tap to change'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => _showLanguagePicker(),
        ),
        const Divider(height: 1),
        // AI Setup tile with live key status
        ListTile(
          leading: Icon(
            AppConfig.isGeminiConfigured ? Icons.smart_toy : Icons.key,
            color: AppConfig.isGeminiConfigured ? AppColors.success : AppColors.warning,
          ),
          title: const Text('AI Configuration'),
          subtitle: Text(
            AppConfig.isGeminiConfigured
                ? '✅ Gemini key active (${AppConfig.geminiModel})'
                : '⚠️ API key not configured — tap to setup',
            style: TextStyle(
              color: AppConfig.isGeminiConfigured ? AppColors.success : AppColors.warning,
              fontSize: 12, fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApiKeySetupScreen())),
        ),
        const Divider(height: 1),
        ListTile(leading: const Icon(Icons.camera_alt, color: AppColors.cyan),
            title: const Text('Proximity Alerts'),
            subtitle: const Text('Camera-based screen distance detection'),
            trailing: Switch(
              value: ProximityAlertService.instance.isRunning,
              activeThumbColor: AppColors.cyan,
              onChanged: (v) {
                if (v) {
                  ProximityAlertService.instance.start();
                } else {
                  ProximityAlertService.instance.stop();
                }
                setState(() {});
              },
            )),
        const Divider(height: 1),
        ListTile(leading: const Icon(Icons.timer_outlined, color: AppColors.teal),
            title: const Text('20-20-20 Rule'),
            subtitle: const Text('Break reminders every 20 minutes'),
            trailing: Switch(
              value: VisionBreakService.instance.isActive,
              activeThumbColor: AppColors.teal,
              onChanged: (v) async {
                await VisionBreakService.instance.toggle(v);
                setState(() {});
              },
            )),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.local_hospital, color: AppColors.violet),
          title: const Text('Surgery Guide'),
          subtitle: const Text('Pre & post-operative information'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SurgeryInfoHub())),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.elderly, color: AppColors.warning),
          title: const Text('Elderly Easy View'),
          subtitle: const Text('High-contrast, voice-guided interface'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElderlyModeScreen())),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.public, color: AppColors.teal),
          title: const Text('WHO Standards'),
          subtitle: const Text('Global eye health compliance info'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WhoStandardsScreen())),
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(ConnectivityService.instance.isOnline ? Icons.wifi : Icons.wifi_off,
              color: ConnectivityService.instance.isOnline ? AppColors.success : AppColors.error),
          title: const Text('Network Status'),
          subtitle: Text(ConnectivityService.instance.isOnline ? 'Online — All features available' : 'Offline — Limited functionality'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.error),
          title: const Text('Sign Out'),
          onTap: () async {
            await AuthService.instance.signOut();
            if (mounted) Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ])),
    ]));
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF10142A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Select Language', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: TranslatorService.supportedLanguages.length,
              itemBuilder: (_, i) {
                final lang = TranslatorService.supportedLanguages[i];
                final selected = lang.code == TranslatorService.instance.currentLanguageCode;
                return ListTile(
                  leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(lang.name, style: TextStyle(color: selected ? AppColors.cyan : Colors.white)),
                  trailing: selected ? const Icon(Icons.check, color: AppColors.cyan) : null,
                  onTap: () async {
                    await TranslatorService.instance.setLanguage(lang);
                    if (mounted) { Navigator.pop(context); setState(() {}); }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  void _noPatientSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a patient first.')));
  }

  Widget _buildNetworkIndicator() {
    final isOnline = _syncService.isOnline;
    final isSyncing = _syncService.isSyncing;

    return Tooltip(
      message: isSyncing
          ? 'OpthaS AI Syncing...'
          : (isOnline ? 'System Online' : 'System Offline (Caching)'),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSyncing
              ? Colors.amber
              : (isOnline ? AppColors.success : AppColors.error),
          boxShadow: [
            BoxShadow(
              color: (isSyncing
                      ? Colors.amber
                      : (isOnline ? AppColors.success : AppColors.error))
                  .withValues(alpha: 0.5),
              blurRadius: 6,
              spreadRadius: 2,
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: AdaptiveCard(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
      ]),
    ));
  }
}

class _QuickAction extends StatefulWidget {
  final dynamic icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.gradient, required this.onTap});
  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        HapticFeedback.lightImpact();
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _pressed ? Matrix4.diagonal3Values(0.96, 0.96, 1.0) : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.colors.last.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.1,
                child: widget.icon is FaIconData 
                  ? FaIcon(widget.icon as FaIconData, color: Colors.white, size: 60)
                  : Icon(widget.icon as IconData, color: Colors.white, size: 60),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: widget.icon is FaIconData 
                    ? FaIcon(widget.icon as FaIconData, color: Colors.white, size: 20)
                    : Icon(widget.icon as IconData, color: Colors.white, size: 20),
                ),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
