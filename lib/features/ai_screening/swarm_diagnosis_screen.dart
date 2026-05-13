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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/python_api_service.dart';

class SwarmDiagnosisScreen extends StatefulWidget {
  final String symptoms;
  const SwarmDiagnosisScreen({super.key, required this.symptoms});

  @override
  State<SwarmDiagnosisScreen> createState() => _SwarmDiagnosisScreenState();
}

class _SwarmDiagnosisScreenState extends State<SwarmDiagnosisScreen> {
  bool _isDebating = true;
  final List<Map<String, dynamic>> _visibleDebate = [];
  String _finalDiagnosis = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startSwarm();
  }

  Future<void> _startSwarm() async {
    final result = await PythonApiService.instance.runSwarmDiagnosis(widget.symptoms);
    
    if (result['status'] == 'success') {
      final List<dynamic> fullDebate = result['debate'];
      
      // Simulate real-time arrival of messages
      for (var msg in fullDebate) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 1200));
        setState(() {
          _visibleDebate.add(msg as Map<String, dynamic>);
        });
        _scrollToBottom();
        HapticFeedback.lightImpact();
      }

      if (mounted) {
        setState(() {
          _finalDiagnosis = result['final_diagnosis'];
          _isDebating = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _finalDiagnosis = 'Error: ${result['message']}';
          _isDebating = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('OpthaS AI Swarm Brain'),
        backgroundColor: const Color(0xFF0A0E1A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E1A), Color(0xFF1E2235)],
          ),
        ),
        child: Column(
          children: [
            // Status Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: AdaptiveCard(
                child: Row(
                  children: [
                    const Icon(Icons.hub, color: AppColors.cyan, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Multi-Agent Consensus Mode',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _isDebating ? 'Agents are debating your case...' : 'Consensus reached.',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (_isDebating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan),
                      ),
                  ],
                ),
              ),
            ),

            // Debate Feed
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _visibleDebate.length,
                itemBuilder: (context, index) {
                  final msg = _visibleDebate[index];
                  final isSystem = msg['agent'].startsWith('System');
                  final isGraph = msg['agent'].contains('GraphRAG');
                  final isMemory = msg['agent'].contains('Memory');
                  final isCMO = msg['agent'] == 'Chief Medical Officer (AI)';
                  final isPediatric = msg['agent'].contains('Kids');
                  final isOncology = msg['agent'].contains('Onco');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: isSystem ? Alignment.center : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isGraph 
                              ? AppColors.success.withValues(alpha: 0.1)
                              : isMemory 
                                  ? AppColors.warning.withValues(alpha: 0.1)
                                  : isCMO 
                                      ? AppColors.violet.withValues(alpha: 0.15)
                                      : isPediatric
                                          ? Colors.pink.withValues(alpha: 0.1)
                                          : isOncology
                                              ? Colors.redAccent.withValues(alpha: 0.1)
                                              : const Color(0xFF2A2E45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isGraph 
                                ? AppColors.success.withValues(alpha: 0.5)
                                : isMemory 
                                    ? AppColors.warning.withValues(alpha: 0.5)
                                    : isCMO 
                                        ? AppColors.violet.withValues(alpha: 0.5) 
                                        : isPediatric
                                            ? Colors.pink.withValues(alpha: 0.5)
                                            : isOncology
                                                ? Colors.redAccent.withValues(alpha: 0.5)
                                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isGraph ? Icons.auto_graph : isMemory ? Icons.history : isPediatric ? Icons.child_care : isOncology ? Icons.biotech : Icons.person,
                                  size: 14,
                                  color: isGraph ? AppColors.success : isMemory ? AppColors.warning : isPediatric ? Colors.pink : isOncology ? Colors.redAccent : AppColors.cyan,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  msg['agent'],
                                  style: TextStyle(
                                    color: isGraph 
                                        ? AppColors.success 
                                        : isMemory 
                                            ? AppColors.warning 
                                            : isPediatric
                                                ? Colors.pink
                                                : isOncology
                                                    ? Colors.redAccent
                                                    : (isCMO ? AppColors.violet : AppColors.cyan),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              msg['message'],
                              style: const TextStyle(color: Colors.white, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Final Result
            if (!_isDebating)
              Padding(
                padding: const EdgeInsets.all(20),
                child: AdaptiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'FINAL DIAGNOSTIC CONSENSUS',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _finalDiagnosis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet),
                        child: const Text('Acknowledge Findings'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
