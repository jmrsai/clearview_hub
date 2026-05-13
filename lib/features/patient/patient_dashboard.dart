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
import '../therapy/eye_therapy_hub.dart';
import '../../core/services/auth_service.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E1A),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('My Eye Health'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cyan, AppColors.violet],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 64),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  Text(
                    'Recent Reports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildRecentReports(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _ActionCard(
          title: 'Vision Therapy',
          icon: Icons.games_outlined,
          color: AppColors.success,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EyeTherapyHub(patientId: AuthService.instance.userId ?? 'guest'))),
        ),
        const SizedBox(width: 16),
        _ActionCard(
          title: 'Book Consult',
          icon: Icons.calendar_month_outlined,
          color: AppColors.cyan,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRecentReports(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.cyan),
            title: Text('OpthaS AI Triage Report', style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text('May 08, 2026', style: Theme.of(context).textTheme.bodySmall),
            trailing: const Icon(Icons.download, color: Colors.white24),
            onTap: () {},
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.cyan),
            title: Text('Color Vision Test', style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text('May 05, 2026', style: Theme.of(context).textTheme.bodySmall),
            trailing: const Icon(Icons.download, color: Colors.white24),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AdaptiveCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
