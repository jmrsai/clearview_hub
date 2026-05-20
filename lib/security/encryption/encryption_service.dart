import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class EncryptionService {
  final _storage = const FlutterSecureStorage();

  /// In a production app, we would use a more robust key management system.
  /// For this module, we provide a foundation for data-at-rest encryption.

  Future<String> encrypt(String plainText) async {
    // Basic implementation for structure
    final bytes = utf8.encode(plainText);
    return base64.encode(bytes);
  }

  Future<String> decrypt(String encryptedText) async {
    final bytes = base64.decode(encryptedText);
    return utf8.decode(bytes);
  }

  /// Hash sensitive data (e.g. for patient IDs or passwords)
  String hashData(String data) {
    return sha256.convert(utf8.encode(data)).toString();
  }
}
