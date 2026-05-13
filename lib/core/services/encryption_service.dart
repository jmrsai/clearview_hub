import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:typed_data';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _storage = const FlutterSecureStorage();
  late Key _key;
  late IV _iv;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Retrieve or generate master key
    String? storedKey = await _storage.read(key: 'master_encryption_key');
    if (storedKey == null) {
      final newKey = Key.fromSecureRandom(32);
      await _storage.write(key: 'master_encryption_key', value: newKey.base64);
      _key = newKey;
    } else {
      _key = Key.fromBase64(storedKey);
    }

    // Fixed IV for HIPAA compliance (or randomized per record if preferred)
    // Here we use a stored IV to ensure we can decrypt later.
    String? storedIV = await _storage.read(key: 'master_iv');
    if (storedIV == null) {
      final newIV = IV.fromSecureRandom(16);
      await _storage.write(key: 'master_iv', value: newIV.base64);
      _iv = newIV;
    } else {
      _iv = IV.fromBase64(storedIV);
    }

    _isInitialized = true;
  }

  /// Encrypt a string (e.g. JSON patient data)
  String encryptString(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt a string
  String decryptString(String encryptedBase64) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
    return decrypted;
  }

  /// Encrypt bytes (e.g. Retinal images)
  Uint8List encryptBytes(Uint8List data) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encryptBytes(data, iv: _iv);
    return encrypted.bytes;
  }

  /// Decrypt bytes
  Uint8List decryptBytes(Uint8List encryptedData) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decryptBytes(Encrypted(encryptedData), iv: _iv);
    return Uint8List.fromList(decrypted);
  }
}
