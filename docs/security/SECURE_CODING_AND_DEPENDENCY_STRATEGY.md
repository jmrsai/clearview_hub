# SECURE CODING, DEPENDENCIES & KEY MANAGEMENT

This document defines the engineering standards for maintaining a secure-by-default codebase and managing the cryptographic lifecycle.

## 1. Secure Coding Standards
*   **Input Sanitization:** All user input (Community posts, Chat messages) is treated as untrusted and sanitized to prevent XSS and Injection.
*   **No Hardcoded Secrets:** Secrets are injected at runtime via AWS Secrets Manager or Vault.
*   **Memory Management:** Sensitive data is explicitly cleared from memory after use (e.g., zeroing out buffers containing decrypted keys).
*   **Error Handling:** Generic error messages are shown to users to prevent information leakage (e.g., "Invalid credentials" instead of "User not found").

## 2. Dependency Management Strategy
*   **SBOM (Software Bill of Materials):** Generated on every build to track all transitive dependencies.
*   **Automated Scanning:** Snyk/Trivy scans for vulnerabilities in third-party libraries.
*   **Lockfiles:** `pubspec.lock` and `package-lock.json` are committed to ensure deterministic and verified builds.
*   **Minimalism:** Avoid importing large libraries for small utility functions to reduce the attack surface.

## 3. Key Management Strategy (KMS)
*   **Master Keys:** Stored in FIPS 140-2 Level 3 Hardware Security Modules (HSMs).
*   **Data Keys:** Generated per-patient or per-record, encrypted by the Master Key (Envelope Encryption).
*   **Key Rotation:** Automatic rotation of database and API signing keys every 90 days.
*   **Revocation:** Immediate revocation capability for compromised device tokens or service credentials.
