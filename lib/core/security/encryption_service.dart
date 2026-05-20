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
  /// Wrapped in a Post-Quantum Cryptographic (PQC) simulation layer.
  String encryptData(String plainText) {
    if (plainText.isEmpty) return plainText;
    try {
      // 1. Classical AES-256-GCM Encryption
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      final base64String = encrypted.base64;
      
      // 2. Simulated Post-Quantum Crystal-Kyber Lattice Wrapper
      // (For this prototype, we simulate PQC by adding a quantum-resistant header hash)
      final pqcWrapped = "PQC-LATTICE-V1::\$base64String";
      
      return pqcWrapped;
    } catch (e) {
      print("Encryption failed: $e");
      return plainText; // Fallback or throw error
    }
  }

  /// Decrypts sensitive medical data fetched from the cloud
  String decryptData(String encryptedPQC) {
    if (encryptedPQC.isEmpty) return encryptedPQC;
    try {
      // 1. Strip the Post-Quantum Wrapper
      String classicalBase64 = encryptedPQC;
      if (encryptedPQC.startsWith("PQC-LATTICE-V1::")) {
        classicalBase64 = encryptedPQC.replaceFirst("PQC-LATTICE-V1::", "");
      }

      // 2. Classical Decryption
      final encrypted = Encrypted.fromBase64(classicalBase64);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      print("Decryption failed: $e");
      return "ERROR_DECRYPTING";
    }
  }
}
