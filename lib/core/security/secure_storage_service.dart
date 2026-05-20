import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Enterprise-grade Secure Storage Manager.
/// Handles the secure persistence of JWTs, Refresh Tokens, and
/// generates/stores the AES-256 key required for the local offline Hive database.
class SecureStorageService {
  static const String _encryptionKeyName = 'eyeverse_offline_db_key';
  
  // Use specific iOS/Android options for maximum security
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initializes the Hive database with a secure encryption key.
  /// If the key doesn't exist in the Keystore/Keychain, it generates a new one.
  Future<void> initSecureOfflineDatabase(String boxName) async {
    String? encryptionKeyString = await _secureStorage.read(key: _encryptionKeyName);
    
    if (encryptionKeyString == null) {
      // Generate a new secure 256-bit AES key
      final secureKey = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64UrlEncode(secureKey),
      );
      encryptionKeyString = base64UrlEncode(secureKey);
    }

    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);

    // Open the box with the AES cipher
    await Hive.openBox(
      boxName,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }

  /// Securely stores the session refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'auth_refresh_token', value: token);
  }

  /// Retrieves the session refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'auth_refresh_token');
  }

  /// Securely wipes all cryptographic keys and tokens (e.g., on logout or tamper detection)
  Future<void> wipeAllSecureData() async {
    await _secureStorage.deleteAll();
  }
}
