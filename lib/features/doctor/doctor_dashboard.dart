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
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/patient.dart';
import '../../core/services/firestore_service.dart';
import '../ai_screening/opthas_ai_dashboard.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Clinical Command Center'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.graphic_eq, color: AppColors.violet), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OpthaSAIDashboard()));
          }),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<List<Patient>>(
        stream: FirestoreService.instance.getPatients(),
        builder: (context, snapshot) {
          final patients = snapshot.data ?? [];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSummary(),
                const SizedBox(height: 32),
                Text(
                  'My Patients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (patients.isEmpty)
                  const Center(child: Text('No patients assigned yet.', style: TextStyle(color: Colors.white24)))
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: patients.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _PatientClinicalCard(patient: patients[index]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        _StatBox(title: 'Active Triage', value: '12', color: AppColors.cyan),
        const SizedBox(width: 16),
        _StatBox(title: 'Critical Cases', value: '3', color: AppColors.error),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatBox({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AdaptiveCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _PatientClinicalCard extends StatelessWidget {
  final Patient patient;
  const _PatientClinicalCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
          child: Text(patient.initials, style: const TextStyle(color: AppColors.cyan)),
        ),
        title: Text(patient.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('${patient.age} years • ${patient.gender}', style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {
          // Navigate to Patient Clinical Detail
        },
      ),
    );
  }
}
