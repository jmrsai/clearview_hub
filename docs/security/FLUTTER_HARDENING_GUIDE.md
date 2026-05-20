# FLUTTER APP HARDENING & MOBILE DEFENSE GUIDE

This guide details the defensive measures required to secure the Flutter client against reverse engineering, tampering, malware, and data extraction.

## 1. Anti-Tampering & Runtime Integrity
*   **Root & Jailbreak Detection:** Implement mechanisms (e.g., `flutter_jailbreak_detection` or custom native channels) to detect compromised environments. If a compromised OS is detected, the app must securely wipe local PHI and refuse to run (Fail Securely).
*   **Emulator & Hooking Detection:** Prevent execution on emulators and detect dynamic instrumentation frameworks (e.g., Frida, Xposed) to thwart reverse engineering attempts.
*   **Play Integrity API (Android) / App Attest (iOS):** The app must generate cryptographic attestations of its integrity and the device's security posture. The backend verifies these tokens before granting access to sensitive APIs or downloading medical data.

## 2. Code Obfuscation & Build Security
*   **Dart Obfuscation:** The release build MUST use the `--obfuscate` flag combined with `--split-debug-info`.
    ```bash
    flutter build apk --obfuscate --split-debug-info=./debug_info
    ```
*   **Native Obfuscation:** Enable ProGuard/R8 in `android/app/build.gradle` to shrink, optimize, and obfuscate native Android code.
*   **Symbol Stripping:** Ensure native symbols are stripped from release binaries to complicate reverse engineering.

## 3. Network Defense & SSL Pinning
*   **Certificate Pinning:** To prevent Man-In-The-Middle (MITM) attacks, the app must verify the server's SSL certificate against a pre-defined set of pins (SHA-256 hashes of the public key). This ensures the app only communicates with genuine EyeVerse servers, even if a CA is compromised or a user installs a malicious root certificate.
*   **Secure HTTP Client:** Use `Dio` with strict interceptors to ensure all requests use TLS 1.3 and reject cleartext HTTP.

## 4. Encrypted Offline Storage & Memory Protection
*   **Hardware-Backed Keystore:** Use `flutter_secure_storage` to leverage the Android Keystore and iOS Keychain. Store sensitive tokens (JWTs, Refresh Tokens) and the master encryption key for the local database here.
*   **Encrypted Database:** Offline medical data (cached in Hive or Isar) MUST be encrypted using AES-256-GCM. The encryption key is retrieved from the secure storage at runtime.
*   **Secure Clipboard & Screen Capture:** Implement platform channels to prevent taking screenshots or screen recordings on highly sensitive screens (e.g., Viewing Medical Reports or Telemedicine video calls). Use `FLAG_SECURE` on Android.
*   **Memory Protection:** Clear sensitive data (like passwords or decrypted PHI) from memory explicitly when no longer needed, rather than waiting for garbage collection.

## 5. Authentication & Biometrics
*   **Local Authentication:** Enforce biometric re-authentication (FaceID/TouchID) via `local_auth` before opening the app from the background or accessing the "Medical History" section.
*   **Secure Session Management:** Implement idle timeouts. If the app is inactive for a set period, the session locks and requires biometric unlock.

## 6. Malware & Abuse Defense
*   **Upload Validation:** If patients upload prescriptions or documents, the app must strictly validate MIME types and file extensions before sending them to the backend, where they undergo rigorous antivirus scanning in an isolated sandbox.
*   **Device Reputation:** Monitor device signals and pass them to the backend risk engine to assess the likelihood of the device being part of a botnet or malware campaign.
