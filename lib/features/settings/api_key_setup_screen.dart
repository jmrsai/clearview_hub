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
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';

/// Shown when the Gemini API key is not configured.
/// Guides users through the setup process step by step.
class ApiKeySetupScreen extends StatefulWidget {
  const ApiKeySetupScreen({super.key});
  @override
  State<ApiKeySetupScreen> createState() => _ApiKeySetupScreenState();
}

class _ApiKeySetupScreenState extends State<ApiKeySetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeIn;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isConfigured = AppConfig.isGeminiConfigured;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              // Header
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.key, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AI Setup', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  Text('Configure your Gemini AI key', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ])),
              ]),

              const SizedBox(height: 28),

              // Status banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isConfigured ? AppColors.success : AppColors.error).withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: (isConfigured ? AppColors.success : AppColors.error).withAlpha(80)),
                ),
                child: Row(children: [
                  Icon(isConfigured ? Icons.check_circle : Icons.warning_amber_rounded,
                      color: isConfigured ? AppColors.success : AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    isConfigured
                        ? '✅ API key configured! All AI features are active.'
                        : '⚠️ API key not found in .env file. AI features are disabled.',
                    style: TextStyle(
                      color: isConfigured ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600, fontSize: 13,
                    ),
                  )),
                ]),
              ),

              const SizedBox(height: 28),

              const Text('Setup Steps', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              _SetupStep(
                number: 1,
                title: 'Get a Gemini API Key',
                body: 'Visit Google AI Studio and create a free API key. No credit card required.',
                isActive: _currentStep == 0,
                isComplete: _currentStep > 0,
                action: ElevatedButton.icon(
                  onPressed: () => _openUrl('https://aistudio.google.com/app/apikey'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.cyan),
                  icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                  label: const Text('Open AI Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                onTap: () => setState(() => _currentStep = 0),
              ),

              _SetupStep(
                number: 2,
                title: 'Copy your API key',
                body: 'In AI Studio, click "Create API key in new project". Copy the key (starts with "AIza...").',
                isActive: _currentStep == 1,
                isComplete: _currentStep > 1,
                action: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentStep = 2),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Done, key copied'),
                ),
                onTap: () => setState(() => _currentStep = 1),
              ),

              _SetupStep(
                number: 3,
                title: 'Edit the .env file',
                body: 'Open the .env file in your project root. Replace:\n\n'
                    'GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE\n\nwith your actual key.',
                isActive: _currentStep == 2,
                isComplete: _currentStep > 2,
                action: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cyan.withAlpha(60)),
                    ),
                    child: Row(children: [
                      const Expanded(child: Text('GEMINI_API_KEY=AIzaSy...', style: TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 12))),
                      IconButton(
                        icon: const Icon(Icons.copy, color: AppColors.textHint, size: 16),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: 'GEMINI_API_KEY='));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Template copied to clipboard')),
                          );
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _currentStep = 3),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('.env updated'),
                  ),
                ]),
                onTap: () => setState(() => _currentStep = 2),
              ),

              _SetupStep(
                number: 4,
                title: 'Restart the app',
                body: 'Hot restart the app (Shift+R in terminal or press the restart button). '
                    'The .env file is loaded at startup.',
                isActive: _currentStep == 3,
                isComplete: false,
                action: const Text('The status banner at the top will turn green ✅ when successful.',
                    style: TextStyle(color: AppColors.success, fontSize: 12)),
                onTap: () => setState(() => _currentStep = 3),
              ),

              const SizedBox(height: 24),

              // What AI unlocks
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.violet.withAlpha(40), AppColors.cyan.withAlpha(20)]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.violet.withAlpha(80)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('What the AI key unlocks:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 12),
                  _FeatureRow('👁️', 'AI Retinal Screening', 'Gemini Vision analyzes eye photos'),
                  _FeatureRow('🤖', 'MedAssist AI Chatbot', 'Strict medical Q&A with guardrails'),
                  _FeatureRow('📄', 'Prescription OCR Parser', 'Auto-extract medicines from prescriptions'),
                  _FeatureRow('🩺', 'AI Symptom Analyzer', 'Differential diagnosis triage'),
                  _FeatureRow('🔬', 'Surgery Info AI', 'Pre/post-operative guidance'),
                  _FeatureRow('🌍', 'Medical Translator', 'Translate health content to any language'),
                ]),
              ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  '🔒 Your API key is stored only in the .env file on your device. '
                  'It is excluded from version control via .gitignore. '
                  'Never share your key or commit the .env file.',
                  style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.5),
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SetupStep extends StatelessWidget {
  final int number;
  final String title;
  final String body;
  final bool isActive;
  final bool isComplete;
  final Widget action;
  final VoidCallback onTap;
  const _SetupStep({required this.number, required this.title, required this.body, required this.isActive, required this.isComplete, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? AppColors.success : isActive ? AppColors.cyan : AppColors.textHint;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E2235) : const Color(0xFF141824),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(isActive ? 120 : 40)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
              child: Center(child: isComplete
                ? Icon(Icons.check, color: color, size: 16)
                : Text('$number', style: TextStyle(color: color, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 15)),
          ]),
          if (isActive) ...[
            const SizedBox(height: 10),
            Text(body, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
            const SizedBox(height: 12),
            action,
          ],
        ]),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  const _FeatureRow(this.emoji, this.title, this.desc);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(desc, style: TextStyle(color: AppColors.textHint, fontSize: 11)),
      ])),
    ]),
  );
}
