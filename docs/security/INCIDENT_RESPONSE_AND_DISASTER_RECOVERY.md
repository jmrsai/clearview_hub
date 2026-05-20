# INCIDENT RESPONSE & DISASTER RECOVERY (IR/DR)

This plan ensures business continuity and data integrity in the event of a security breach or infrastructure failure.

## 1. Incident Response (IR) Phases
1.  **Preparation:** Ongoing training and SIEM monitoring.
2.  **Identification:** Automated alerts from Wazuh/Prometheus.
3.  **Containment:** Immediate isolation of compromised K8s pods or revoking suspicious IP access at the WAF.
4.  **Eradication:** Removing the root cause (e.g., patching a zero-day or deleting malware-laden uploads).
5.  **Recovery:** Restoring services from clean, verified immutable backups.
6.  **Lessons Learned:** Post-mortem analysis and adjustment of threat models.

## 2. Disaster Recovery (DR) Strategy
*   **RPO (Recovery Point Objective):** 15 minutes (Database snapshots taken every 15 mins).
*   **RTO (Recovery Time Objective):** 2 hours (Automated Terraform failover to secondary AWS region).
*   **Data Resilience:**
    *   Multi-Region Database Replication (PostgreSQL Read Replicas).
    *   Cross-Region S3 Bucket Versioning and Replication for medical media.
*   **Pilot Light Approach:** A minimal version of the infrastructure is always running in a standby region, ready to scale up instantly.

## 3. Data Integrity Verification
*   **Backup Verification:** Monthly automated restores of backups to a sandbox environment to ensure data is not corrupted and can be successfully decrypted.
