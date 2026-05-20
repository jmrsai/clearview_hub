import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(
    String email,
    String password, {
    String? name,
  });
  Future<void> signOut();
  Future<UserEntity> signInAsGuest();
  Future<bool> authenticateWithBiometrics();
}
