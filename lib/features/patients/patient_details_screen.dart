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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../models/patient.dart';
import '../../models/vision_test_result.dart';
import '../../models/medication_log.dart';
import '../vision_tests/vision_tests_hub.dart';
import '../../core/services/clinical_report_service.dart';
import 'add_exam_screen.dart';
import 'ai_patient_summary_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;
  const PatientDetailsScreen({super.key, required this.patient});
  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<EyeExam> _exams = [];
  List<VisionTestResult> _tests = [];
  List<MedicationLog> _meds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    final exams = await db.getExamsForPatient(widget.patient.id);
    final tests = await db.getVisionTestsForPatient(widget.patient.id);
    final meds  = await db.getMedicationLogsForPatient(widget.patient.id);
    if (mounted) setState(() { _exams = exams; _tests = tests; _meds = meds; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;
    return AdaptiveScaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            color: AppColors.violet,
            tooltip: 'AI Patient Summary',
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) => AiPatientSummaryScreen(patient: p)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.description_outlined),
            color: AppColors.cyan,
            tooltip: 'Generate Clinical Report',
            onPressed: () {
              HapticFeedback.lightImpact();
              _generateReport();
            },
          ),
          IconButton(icon: const Icon(Icons.visibility), color: AppColors.cyan,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) => VisionTestsHub(patientId: p.id))).then((_) => _load());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExamScreen(patient: widget.patient)),
          ).then((_) => _load());
        },
        label: const Text('Add Exam'),
        icon: const Icon(Icons.add_chart),
        backgroundColor: AppColors.cyan,
      ),
      body: SafeArea(child: Column(children: [
        // Patient header card
        Padding(padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
          child: AdaptiveCard(
            child: Row(children: [
              Hero(
                tag: 'avatar-${p.id}',
                child: CircleAvatar(radius: 30, backgroundColor: AppColors.cyanDim,
                  child: Text(p.initials, style: const TextStyle(
                      color: AppColors.cyan, fontWeight: FontWeight.w800, fontSize: 20))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: Theme.of(context).textTheme.titleLarge),
                Text('${p.gender}, ${p.age} yrs  ·  ID: ${p.id}',
                    style: Theme.of(context).textTheme.bodyMedium),
                if (p.diagnosis != null)
                  Chip(label: Text(p.diagnosis!,
                      style: const TextStyle(fontSize: 11, color: AppColors.warning)),
                      backgroundColor: AppColors.warning.withAlpha(30),
                      side: const BorderSide(color: AppColors.warning, width: 1)),
              ])),
            ]),
          ),
        ),
        // Tabs
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TabBar(controller: _tab,
            indicatorColor: AppColors.cyan,
            labelColor: AppColors.cyan,
            unselectedLabelColor: AppColors.textHint,
            onTap: (index) => HapticFeedback.lightImpact(),
            tabs: const [Tab(text: 'Exams'), Tab(text: 'Tests'), Tab(text: 'Meds')],
          ),
        ),
        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
            : TabBarView(controller: _tab, children: [
                _examsTab(),
                _testsTab(),
                _medsTab(),
              ])),
      ])),
    );
  }

  Widget _examsTab() {
    if (_exams.isEmpty) return _empty('No exams recorded', Icons.assignment);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: _exams.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final e = _exams[i];
        return AdaptiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Exam — ${_fmt(e.date)}', style: Theme.of(context).textTheme.titleMedium),
                  const Icon(Icons.verified, color: AppColors.cyan, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _metricTile('VA Left (OS)', e.visualAcuityLeft, AppColors.violet),
                  const SizedBox(width: 8),
                  _metricTile('VA Right (OD)', e.visualAcuityRight, AppColors.cyan),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _metricTile('IOP Left', '${e.intraocularPressureLeft} mmHg', AppColors.teal),
                  const SizedBox(width: 8),
                  _metricTile('IOP Right', '${e.intraocularPressureRight} mmHg', AppColors.teal),
                ],
              ),
              if (e.notes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Colors.white12),
                ),
                Text('Clinical Notes:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(e.notes, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _testsTab() {
    if (_tests.isEmpty) return _empty('No vision tests yet', Icons.visibility);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _tests.length,
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final t = _tests[i];
        return AdaptiveCard(child: Row(children: [
          Container(width: 4, height: 48,
            decoration: BoxDecoration(
              color: _testColor(t.testType),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_testLabel(t.testType), style: Theme.of(context).textTheme.titleMedium),
            Text(_fmt(t.performedAt), style: Theme.of(context).textTheme.bodyMedium),
          ])),
          if (t.acuityLeft.isNotEmpty)
            Column(children: [
              Text(t.acuityLeft, style: const TextStyle(color: AppColors.violet,
                  fontWeight: FontWeight.w700, fontSize: 13)),
              Text(t.acuityRight, style: const TextStyle(color: AppColors.cyan,
                  fontWeight: FontWeight.w700, fontSize: 13)),
            ]),
        ]));
      },
    );
  }

  Widget _medsTab() {
    if (_meds.isEmpty) return _empty('No medications logged', Icons.medication);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _meds.length,
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final m = _meds[i];
        final color = m.isTaken ? AppColors.success : m.isMissed ? AppColors.error : AppColors.warning;
        return AdaptiveCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(children: [
            Icon(m.isTaken ? Icons.check_circle : m.isMissed ? Icons.cancel : Icons.schedule,
                color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.medicationName, style: Theme.of(context).textTheme.titleMedium),
              Text('${m.dosage}  ·  ${_fmt(m.scheduledAt)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(6)),
              child: Text(m.status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color))),
          ]),
        );
      },
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _empty(String msg, IconData icon) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, size: 56, color: AppColors.textHint),
    const SizedBox(height: 12),
    Text(msg, style: Theme.of(context).textTheme.bodyMedium),
  ]));

  void _generateReport() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.cyan)),
    );
    
    try {
      final pdfBytes = await ClinicalReportService.instance.generatePdfReport(widget.patient);
      if (mounted) {
        Navigator.pop(context); // Remove loader
        await ClinicalReportService.instance.printReport(widget.patient, pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate report: $e')),
        );
      }
    }
  }

  Color _testColor(String type) =>
      type == 'snellen' ? AppColors.cyan : type == 'amsler' ? AppColors.violet : type == 'ai_screening' ? AppColors.error : AppColors.success;

  String _testLabel(String type) =>
      type == 'snellen' ? 'Snellen Chart' : type == 'amsler' ? 'Amsler Grid' : type == 'ai_screening' ? 'AI Screening' : 'Color Vision';

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
}
