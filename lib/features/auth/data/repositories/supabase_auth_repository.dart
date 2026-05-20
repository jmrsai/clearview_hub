import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;
    
    final user = session.user;
    
    // Fetch profile data for role and additional info
    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      name: profile['full_name'] as String?,
      avatarUrl: profile['avatar_url'] as String?,
      role: profile['role'] as String?,
    );
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user == null) throw Exception('Login failed');
    
    return (await getCurrentUser())!;
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': name,
      },
    );
    
    if (response.user == null) throw Exception('Registration failed');
    
    return (await getCurrentUser())!;
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserEntity> signInAsGuest() async {
    // Supabase doesn't have a native "guest" mode in the same way, 
    // but we can use anonymous auth if enabled or a mock for now.
    // For "World Best App", we should use Anonymous Auth.
    final response = await _client.auth.signInAnonymously();
    
    if (response.user == null) throw Exception('Guest login failed');
    
    return UserEntity(
      id: response.user!.id,
      email: 'guest@eyeverse.ai',
      isGuest: true,
      name: 'Guest User',
      role: 'patient',
    );
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    // This would typically be handled by a local_auth package 
    // and then potentially used to unlock a stored Supabase session.
    return true; 
  }
}
