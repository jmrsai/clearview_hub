# COMPLIANCE & AUDIT CHECKLISTS

This document ensures the Global Eye Health Platform remains compliant with international healthcare regulations (HIPAA, GDPR) and undergoes rigorous security auditing.

## 1. HIPAA Compliance Checklist (USA)
*   [ ] **Access Control:** Unique user IDs, automated session logouts, and MFA for medical staff.
*   [ ] **Integrity:** Digital signatures on medical reports to detect unauthorized tampering.
*   [ ] **Transmission Security:** TLS 1.3 mandated for all patient data in transit.
*   [ ] **Auditing:** Immutable logs of every access to PHI, stored for a minimum of 6 years.
*   [ ] **Physical Security:** Databases hosted in SOC2/SOC3 certified AWS/GCP data centers with strict physical access controls.

## 2. GDPR Compliance Checklist (EU)
*   [ ] **Consent Management:** Explicit opt-in for data processing and medical research participation.
*   [ ] **Right to Access:** Patient dashboard feature to download all personal medical data in JSON format.
*   [ ] **Right to Erasure:** "Delete Account" button that triggers a cascaded wipe of all PII within 30 days.
*   [ ] **Privacy by Design:** Local-first processing for fatigue AI; no facial images uploaded to cloud (only anonymized metrics).
*   [ ] **Data Residency:** EU user data stored in AWS Frankfurt or Dublin regions.

## 3. Internal Security Audit Checklist
*   [ ] **Weekly:** CI/CD dependency vulnerability scan review.
*   [ ] **Monthly:** AWS IAM role and policy permission audit (Least Privilege check).
*   [ ] **Quarterly:** Review of immutable audit logs for anomalous patterns.
*   [ ] **Bi-Annually:** Secret rotation for all infrastructure and service accounts.
*   [ ] **Annually:** Full-stack penetration test and Disaster Recovery simulation.
