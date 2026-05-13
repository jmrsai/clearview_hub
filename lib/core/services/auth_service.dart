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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_roles.dart';
import 'firestore_service.dart';
import 'audit_service.dart';

/// Result of an authentication attempt.
class AuthResult {
  final bool success;
  final String? error;
  AuthResult({required this.success, this.error});
}

/// Firebase-backed authentication service.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? _user;
  String? _userName;
  String? _userRole;

  bool get isAuthenticated => _user != null;
  User? get user => _user;
  String? get userId => _user?.uid;
  String? get userEmail => _user?.email;
  String? get userName => _userName;
  String? get userRole => _userRole;

  /// Initialize the auth state listener.
  Future<void> init() async {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      await _loadProfile();
      notifyListeners();
    });
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name_${_user!.uid}') ?? _user!.displayName;
      _userRole = await FirestoreService.instance.getUserRole(_user!.uid) ?? 'patient';
    } else {
      _userRole = null;
    }
  }

  /// Sign in with email and password.
  Future<AuthResult> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await AuditService.instance.logLogin();
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message ?? 'Authentication failed');
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// Sign in with Google using Firebase Auth popup/redirect.
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      // Works on both web (popup) and is gracefully handled on mobile
      final UserCredential userCredential = kIsWeb
          ? await _auth.signInWithPopup(googleProvider)
          : await _auth.signInWithProvider(googleProvider);
      if (userCredential.user == null) return AuthResult(success: false, error: 'Sign in failed');
      await AuditService.instance.logAction(action: 'GOOGLE_LOGIN', resource: 'AUTH');
      await AuditService.instance.logLogin();
      return AuthResult(success: true);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// Register a new account.
  Future<AuthResult> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name_${credential.user!.uid}', name);
        _userName = name;
      }
      await AuditService.instance.logAction(action: 'REGISTER', resource: 'AUTH', details: 'Name: $name');
      await AuditService.instance.logLogin();
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: e.message ?? 'Registration failed');
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// Register as a Doctor.
  Future<AuthResult> registerAsDoctor({
    required String name,
    required String email,
    required String password,
    required String specialization,
    required String licenseNumber,
    required String clinicName,
  }) async {
    final result = await register(name, email, password);
    if (result.success && _user != null) {
      final doctor = Doctor(
        uid: _user!.uid,
        name: name,
        email: email,
        specialization: specialization,
        licenseNumber: licenseNumber,
        clinicName: clinicName,
      );
      await FirestoreService.instance.saveDoctorProfile(doctor);
    }
    return result;
  }

  /// Register as an Administrator.
  Future<AuthResult> registerAsAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await register(name, email, password);
    if (result.success && _user != null) {
      final admin = Administrator(
        uid: _user!.uid,
        name: name,
        email: email,
        permissions: ['read', 'write', 'audit'],
      );
      await FirestoreService.instance.saveAdminProfile(admin);
    }
    return result;
  }

  /// Sign out.
  Future<void> signOut() async {
    await AuditService.instance.logLogout();
    await _auth.signOut();
  }

  /// Password reset.
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult(success: true);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }
}
