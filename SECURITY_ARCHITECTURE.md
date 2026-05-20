# MEDICAL DATA SECURITY & COMPLIANCE ARCHITECTURE

This document details the security implementations required to maintain a HIPAA and GDPR-compliant Global Eye Health Platform.

## 1. Data Classification & Storage
*   **PHI (Protected Health Information):** Patient names, medical histories, eye test results, prescriptions, and telemedicine chat logs.
*   **Storage Strategy:**
    *   **At Rest (Cloud):** PostgreSQL databases are encrypted using AES-256 at the volume level (AWS KMS). Column-level encryption is applied to highly sensitive fields (e.g., specific diagnoses).
    *   **At Rest (Mobile):** Local offline caches (Hive/Isar) use `flutter_secure_storage` to generate and securely store a 256-bit encryption key in the device's Keychain (iOS) or Keystore (Android).
    *   **In Transit:** All data movement over the network mandates TLS 1.3.

## 2. Authentication & Authorization (RBAC)
*   **JWT & Refresh Tokens:** The Auth Service issues short-lived Access Tokens (15 minutes) and long-lived, rotating Refresh Tokens (stored securely on device).
*   **Role-Based Access Control (RBAC):**
    *   `Patient`: Can only read/write their own records (`auth.uid() == patient_id`).
    *   `Doctor`: Can read/write records for assigned patients or patients who have explicitly granted temporary access via a secure share link.
    *   `Admin`: Can manage users and system settings, but CANNOT view PHI without explicit cryptographic auditing.

## 3. Telemedicine & WebRTC Security
*   **End-to-End Encryption (E2EE):** Video and audio streams between Doctor and Patient use WebRTC with Datagram Transport Layer Security (DTLS) and Secure Real-time Transport Protocol (SRTP). The server (TURN/STUN) only relays encrypted packets and cannot decrypt the media.

## 4. Audit Logging & Non-Repudiation
*   **The Audit Trail:** Every action (Read, Update, Delete) performed on a `medical_records` or `eye_tests` table triggers a database function that writes an immutable record to the `audit_logs` table.
*   **Log Structure:** `[Timestamp] | [Actor ID & Role] | [Action] | [Target Record ID] | [IP Address]`.
*   Logs are periodically exported to cold storage (S3 Glacier) with a WORM (Write Once, Read Many) policy to prevent tampering.

## 5. Right to Erasure (GDPR)
*   **Automated Deletion:** A dedicated microservice handles "Account Deletion" requests. It cascades the deletion across the relational database, removes associated media from S3, and anonymizes analytics data (removing associations with the user ID) within 30 days of the request.
