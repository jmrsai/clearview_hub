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
import '../../core/services/auth_service.dart';

// ── Login Screen ──────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _specCtrl  = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _clinicCtrl = TextEditingController();
  
  bool _loading = false;
  bool _obscure = true;
  String _selectedRole = 'patient';
  String? _error;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _specCtrl.dispose();
    _licenseCtrl.dispose();
    _clinicCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    final auth = AuthService.instance;
    
    AuthResult result;
    if (_tab.index == 0) {
      result = await auth.signIn(_emailCtrl.text.trim(), _passCtrl.text);
    } else {
      if (_selectedRole == 'doctor') {
        result = await auth.registerAsDoctor(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          specialization: _specCtrl.text.trim(),
          licenseNumber: _licenseCtrl.text.trim(),
          clinicName: _clinicCtrl.text.trim(),
        );
      } else {
        result = await auth.register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
      }
    }

    if (!mounted) return;
    if (result.success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() { _loading = false; _error = result.error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Logo
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColors.cyan.withAlpha(80), blurRadius: 24)],
            ),
            child: const Icon(Icons.visibility, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text('ClearView Hub', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 6),
          Text('AI-Driven Eye Health Platform', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 36),
          AdaptiveCard(
            child: Column(children: [
              TabBar(
                controller: _tab,
                onTap: (index) => setState(() {}),
                indicatorColor: AppColors.cyan,
                labelColor: AppColors.cyan,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [Tab(text: 'Sign In'), Tab(text: 'Register')],
              ),
              const SizedBox(height: 20),
              if (_tab.index == 1) ...[
                // Role Selection
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ChoiceChip(
                    label: const Text('Patient'),
                    selected: _selectedRole == 'patient',
                    onSelected: (v) => setState(() => _selectedRole = 'patient'),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Doctor'),
                    selected: _selectedRole == 'doctor',
                    onSelected: (v) => setState(() => _selectedRole = 'doctor'),
                  ),
                ]),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: 14),
                if (_selectedRole == 'doctor') ...[
                  TextField(
                    controller: _specCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Specialization (e.g. Retina)', prefixIcon: Icon(Icons.medical_services_outlined)),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _licenseCtrl,
                    decoration: const InputDecoration(
                        labelText: 'License Number', prefixIcon: Icon(Icons.badge_outlined)),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _clinicCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Clinic/Hospital Name', prefixIcon: Icon(Icons.location_on_outlined)),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error)),
              ],
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator(color: AppColors.cyan)
                  : ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _submit();
                      },
                      child: Text(_tab.index == 0 ? 'Sign In' : 'Create Account'),
                    ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  setState(() { _loading = true; _error = null; });
                  final navigator = Navigator.of(context);
                  final result = await AuthService.instance.signInWithGoogle();
                  if (!mounted) return;
                  if (result.success) {
                    navigator.pushReplacementNamed('/home');
                  } else {
                    setState(() { _loading = false; _error = result.error; });
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_tab.index == 0 ? "Don't have an account? " : 'Already have an account? ',
                style: Theme.of(context).textTheme.bodyMedium),
            GestureDetector(
              onTap: () => setState(() => _tab.animateTo(_tab.index == 0 ? 1 : 0)),
              child: Text(_tab.index == 0 ? 'Register' : 'Sign In',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cyan)),
            ),
          ]),
        ]),
      ))),
    );
  }
}
