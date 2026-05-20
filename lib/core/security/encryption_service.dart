import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // In a real production app, this key should be generated per-user using PBKDF2
  // and stored securely in the device Keychain/Keystore.
  // For this implementation, we use a static placeholder 32-byte key for AES-256.
  final Key _key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final IV _iv = IV.fromLength(16);
  late final Encrypter _encrypter;

  void initialize() {
    // We use AES in GCM mode for authenticated encryption
    _encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
  }

  /// Encrypts sensitive medical data before syncing to the cloud
  String encryptData(String plainText) {
    if (plainText.isEmpty) return plainText;
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print("Encryption failed: $e");
      return plainText; // Fallback or throw error
    }
  }

  /// Decrypts sensitive medical data fetched from the cloud
  String decryptData(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return encryptedBase64;
    try {
      final encrypted = Encrypted.fromBase64(encryptedBase64);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      print("Decryption failed: $e");
      return "ERROR_DECRYPTING";
    }
  }
}
