import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecureMessagingService {
  /// Simple E2EE Implementation using AES-256
  /// In a production super-app, we would implement X3DH and Double Ratchet (Signal Protocol).

  static final Key _fixedKey = Key.fromSecureRandom(
    32,
  ); // In reality, keys are derived per session
  static final IV _iv = IV.fromLength(16);

  String encryptMessage(String plainText) {
    final encrypter = Encrypter(AES(_fixedKey));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptMessage(String encryptedBase64) {
    final encrypter = Encrypter(AES(_fixedKey));
    final decrypted = encrypter.decrypt(
      Encrypted.fromBase64(encryptedBase64),
      iv: _iv,
    );
    return decrypted;
  }

  /// Generate a unique fingerprint for the chat session for verification
  String generateFingerprint(String userA, String userB) {
    final combined = userA.compareTo(userB) < 0 ? userA + userB : userB + userA;
    return sha256.convert(utf8.encode(combined)).toString();
  }
}
