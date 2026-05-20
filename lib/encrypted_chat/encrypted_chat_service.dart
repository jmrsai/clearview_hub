import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Encrypted Chat Service - End-to-End Encryption
class EncryptedChatService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late encrypt.Key _encryptionKey;
  late encrypt.IV _iv;
  late encrypt.Encrypter _encrypter;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Attempt to load existing key or generate a new one
    String? storedKey = await _secureStorage.read(key: 'e2ee_key');
    String? storedIv = await _secureStorage.read(key: 'e2ee_iv');

    if (storedKey == null || storedIv == null) {
      _encryptionKey = encrypt.Key.fromSecureRandom(32);
      _iv = encrypt.IV.fromSecureRandom(16);

      await _secureStorage.write(key: 'e2ee_key', value: _encryptionKey.base64);
      await _secureStorage.write(key: 'e2ee_iv', value: _iv.base64);
    } else {
      _encryptionKey = encrypt.Key.fromBase64(storedKey);
      _iv = encrypt.IV.fromBase64(storedIv);
    }

    _encrypter = encrypt.Encrypter(
      encrypt.AES(_encryptionKey, mode: encrypt.AESMode.gcm),
    );
    _isInitialized = true;
  }

  String encryptMessage(String plainText) {
    if (!_isInitialized) {
      throw Exception('EncryptedChatService not initialized');
    }
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptMessage(String encryptedBase64) {
    if (!_isInitialized) {
      throw Exception('EncryptedChatService not initialized');
    }
    final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

final encryptedChatServiceProvider = Provider<EncryptedChatService>((ref) {
  return EncryptedChatService();
});
