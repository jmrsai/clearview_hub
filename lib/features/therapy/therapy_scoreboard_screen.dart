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

class TherapyScoreboardScreen extends StatefulWidget {
  final String patientId;
  const TherapyScoreboardScreen({super.key, required this.patientId});

  @override
  State<TherapyScoreboardScreen> createState() => _TherapyScoreboardScreenState();
}

class _TherapyScoreboardScreenState extends State<TherapyScoreboardScreen> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sessions = await DatabaseHelper.instance.getEyeExerciseSessionsForPatient(widget.patientId);
    if (mounted) {
      setState(() {
        _sessions = sessions;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(title: const Text('Therapy Progress')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
            : _sessions.isEmpty
                ? _buildEmptyState()
                : _buildSessionList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('No therapy sessions recorded yet.', style: TextStyle(color: AppColors.textHint)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Go to Hub'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _sessions.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final s = _sessions[index];
        final type = s['exercise_type'] as String;
        final date = DateTime.parse(s['performed_at'] as String);
        final notes = s['notes'] as String? ?? '';
        
        return AdaptiveCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getTypeIcon(type), color: _getTypeColor(type), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getTypeLabel(type), style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (notes.isNotEmpty)
                    Text(notes, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cyan)),
                  Text('${s['duration_seconds']}s', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getTypeColor(String type) {
    if (type.contains('blink')) return AppColors.teal;
    if (type.contains('mfbf')) return AppColors.error;
    if (type.contains('focus')) return AppColors.violet;
    if (type.contains('smooth')) return AppColors.cyan;
    if (type.contains('saccadic')) return AppColors.cyan;
    return AppColors.success;
  }

  IconData _getTypeIcon(String type) {
    if (type.contains('blink')) return Icons.remove_red_eye_outlined;
    if (type.contains('mfbf')) return Icons.remove_red_eye;
    if (type.contains('focus')) return Icons.center_focus_strong;
    if (type.contains('smooth')) return Icons.track_changes;
    if (type.contains('saccadic')) return Icons.bolt;
    return Icons.fitness_center;
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'blink_master_ai': return 'Blink Master (AI)';
      case 'mfbf_red_cyan': return 'MFBF Anaglyph';
      case 'focus_switch': return 'Focus Switch';
      case 'smooth_pursuit': return 'Smooth Pursuit';
      case 'saccadic_trainer': return 'Saccadic Trainer';
      default: return type.replaceAll('_', ' ').toUpperCase();
    }
  }
}
