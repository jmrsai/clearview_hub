# ZERO TRUST & SECURE CLOUD INFRASTRUCTURE ARCHITECTURE

This document outlines the Enterprise-Grade, Defensive Healthcare Security Architecture for the EyeVerse AI Platform. It is designed to thwart data breaches, malware, ransomware, MITM attacks, and supply-chain vulnerabilities.

## 1. Zero Trust Network Architecture (ZTNA)
*   **Principle:** "Never Trust, Always Verify." Every request, whether originating from the public internet or internally between microservices, is treated as hostile until authenticated and authorized.
*   **Service Mesh (Istio):** All internal microservice communication runs through an Envoy proxy sidecar.
*   **mTLS (Mutual TLS):** Enforced globally. Services authenticate each other using short-lived X.509 certificates managed by a central Certificate Authority (e.g., HashiCorp Vault or AWS ACM).
*   **API Gateway (Kong/AWS API Gateway):**
    *   **Strict Ingress:** The only entry point into the VPC.
    *   **WAF Integration:** AWS WAF inspects all incoming traffic for OWASP Top 10 vulnerabilities (SQLi, XSS), anomalous bot traffic, and geographical restrictions.
    *   **Rate Limiting & Throttling:** Defends against DDoS and credential stuffing attacks by enforcing strict rate limits per IP and per user token.

## 2. Advanced Cryptography & Key Management
*   **Algorithms:**
    *   **Data at Rest:** AES-256-GCM for all cloud storage (S3, EBS, RDS).
    *   **Data in Transit:** TLS 1.3 mandated across all endpoints. Perfect Forward Secrecy (PFS) is enforced.
    *   **Password Hashing:** Argon2id with adaptive cost parameters. PBKDF2 serves only as a legacy fallback.
    *   **Digital Signatures:** ECDSA or Ed25519 for JWT signing and commit signatures.
*   **Key Management System (KMS):** HashiCorp Vault or AWS KMS manages all master keys. Keys are automatically rotated every 30-90 days.
*   **Hardware Security Modules (HSM):** Highly sensitive signing operations (e.g., issuing root certs) utilize FIPS 140-2 Level 3 validated HSMs.

## 3. Database Security (PostgreSQL)
*   **Row-Level Security (RLS):** Policies strictly limit access to PHI. A query attempting to fetch records without matching the `auth.uid()` or an explicitly authorized `doctor_id` will return an empty set at the database engine level.
*   **Immutable Audit Logs:** Every DML operation (INSERT, UPDATE, DELETE) on sensitive tables (`patients`, `medical_records`) triggers a function writing to an append-only `audit_log` table. Logs are streamed to a centralized, WORM (Write Once, Read Many) SIEM solution.
*   **Network Segmentation:** Databases reside in private subnets with no direct internet access. Access is strictly limited to authorized microservices and bastion hosts requiring MFA and SSH key rotation.

## 4. API Hardening & Token Management
*   **JWT Rotation:** Access tokens are short-lived (15 mins). Refresh tokens are rotated on every use (Refresh Token Rotation - RTR) to detect and prevent replay attacks or session hijacking.
*   **Headers:** API responses strictly enforce security headers: `Strict-Transport-Security`, `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options`.
*   **Input Validation:** All API inputs undergo strict schema validation (e.g., using Joi in Node.js or Protocol Buffers in Go) to prevent injection and payload tampering.

## 5. Threat Monitoring & Incident Response
*   **SIEM (Security Information and Event Management):** Wazuh or ELK Stack aggregates logs from CloudTrail, K8s audit logs, API Gateway, and Flutter client error reports.
*   **Anomaly Detection:** Machine learning models baseline normal API usage patterns and trigger high-priority alerts for deviations (e.g., a sudden spike in failed login attempts or bulk data exports).
*   **Automated Response:** Integration with AWS Lambda or SOAR tools to automatically block malicious IPs at the WAF level upon detecting active scanning or abuse.
