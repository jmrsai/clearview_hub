# THREAT MODEL & RISK ASSESSMENT (EYEVERSE AI)

This document identifies potential threats to the Global Eye Health Platform and outlines the defensive strategies employed to mitigate these risks, following the STRIDE methodology.

## 1. Threat Identification (STRIDE)

| Threat Category | Description | Mitigation Strategy |
| :--- | :--- | :--- |
| **Spoofing** | Attackers impersonating doctors or patients to access PHI. | MFA (Multi-Factor Auth), Biometric verification, and strict JWT validation. |
| **Tampering** | Malicious modification of medical records or eye test results. | Immutable audit logs, Digital signatures for reports, and DB Row-Level Security. |
| **Repudiation** | A user denying they performed a specific action (e.g., a doctor denying a prescription). | Cryptographically signed audit trails and non-repudiable transaction logs. |
| **Information Disclosure** | Unauthorized exposure of patient data (PII/PHI). | AES-256 encryption at rest, TLS 1.3 in transit, and hardware-backed key storage. |
| **Denial of Service** | DDoS attacks targeting telemedicine or knowledge hubs. | Cloudflare WAF, Rate limiting at API Gateway, and Auto-scaling Kubernetes pods. |
| **Elevation of Privilege** | A patient accessing doctor-only management tools. | Role-Based Access Control (RBAC) enforced at both API and Database levels. |

## 2. High-Risk Asset Inventory
1.  **Patient EHRs:** Highest sensitivity. Protected by multi-layer encryption.
2.  **Telemedicine Video Streams:** Protected by DTLS/SRTP (End-to-End Encryption).
3.  **Doctor Credentials:** Protected by Argon2 hashing and secure session rotation.
4.  **AI Models/Logic:** Protected by code obfuscation and integrity attestations.

## 3. Vulnerability Management
*   **SAST/DAST:** Automated scanning in the CI/CD pipeline (Semgrep, OWASP ZAP).
*   **Bug Bounty:** Ongoing rewards for ethical hackers identifying edge-case leaks.
*   **Regular Pentesting:** Annual third-party penetration testing of cloud and mobile assets.
