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
import '../patients/patient_details_screen.dart';
import '../patients/add_patient_screen.dart';

class PatientListScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const PatientListScreen({super.key, this.onChanged});
  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _all = [];
  List<Patient> _filtered = [];
  final _search = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _search.addListener(_filter);
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  Future<void> _load() async {
    final patients = await DatabaseHelper.instance.getAllPatients();
    if (mounted) setState(() { _all = patients; _filtered = patients; _loading = false; });
  }

  void _filter() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty ? _all : _all.where((p) =>
          p.name.toLowerCase().contains(q) || p.id.toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: AppColors.cyan),
            onPressed: () async {
              HapticFeedback.lightImpact();
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddPatientScreen()));
              if (result is Patient) {
                await DatabaseHelper.instance.insertPatient(result);
                _load();
                widget.onChanged?.call();
              }
            },
          ),
        ],
      ),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 60, 16, 8),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
                hintText: 'Search by name or ID…',
                prefixIcon: Icon(Icons.search, color: AppColors.textHint)),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(children: [
            Text('${_filtered.length} patients', style: Theme.of(context).textTheme.bodyMedium),
          ]),
        ),
        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
            : _filtered.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _PatientTile(patient: _filtered[i], onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(
                          builder: (_) => PatientDetailsScreen(patient: _filtered[i])));
                      _load();
                    }),
                  )),
      ])),
    );
  }

  Widget _emptyState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.people_outline, size: 64, color: AppColors.textHint),
    const SizedBox(height: 16),
    Text('No patients yet', style: Theme.of(context).textTheme.titleLarge),
    const SizedBox(height: 8),
    Text('Tap + to register a new patient', style: Theme.of(context).textTheme.bodyMedium),
  ]));
}

class _PatientTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;
  const _PatientTile({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Hero(
          tag: 'avatar-${patient.id}',
          child: CircleAvatar(radius: 24,
            backgroundColor: AppColors.cyanDim,
            child: Text(patient.initials, style: const TextStyle(
                color: AppColors.cyan, fontWeight: FontWeight.w800, fontSize: 16))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(patient.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text('ID: ${patient.id}  ·  Age ${patient.age}  ·  ${patient.gender}',
              style: Theme.of(context).textTheme.bodyMedium),
          if (patient.diagnosis != null)
            Text(patient.diagnosis!, style: const TextStyle(
                fontSize: 12, color: AppColors.warning)),
        ])),
        const Icon(Icons.chevron_right, color: AppColors.textHint),
      ]),
    );
  }
}
