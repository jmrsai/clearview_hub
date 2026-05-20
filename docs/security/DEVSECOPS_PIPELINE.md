# DEVSECOPS & CI/CD PIPELINE SECURITY

This document outlines the automated security scanning and deployment pipelines that ensure code integrity from commit to production.

## 1. Pipeline Stages (GitHub Actions / GitLab CI)

### A. Pre-Commit / Local
*   **Gitleaks:** Developers run Gitleaks locally via Git hooks to prevent committing API keys, AWS credentials, or hardcoded secrets.

### B. Continuous Integration (CI)
*   **SAST (Static Application Security Testing):**
    *   **Dart/Flutter:** Dart analyzer with strict pedantic rules.
    *   **Backend:** Semgrep or SonarQube scans Go, Node.js, and Python code for vulnerabilities (SQLi, hardcoded secrets, insecure cryptography).
*   **SCA (Software Composition Analysis):**
    *   OWASP Dependency Check or Snyk analyzes `pubspec.yaml`, `package.json`, and `go.mod` for known CVEs in third-party libraries. Builds fail if high/critical vulnerabilities are found.
*   **IaC Scanning:**
    *   Tfsec or Checkov scans Terraform files and Kubernetes manifests for misconfigurations (e.g., overly permissive IAM roles, publicly exposed S3 buckets).

### C. Container Security
*   **Image Scanning:** Docker images are scanned immediately after build using Trivy or Clair.
*   **Minimal Base Images:** Use Alpine or Distroless base images to minimize the attack surface.
*   **Rootless Containers:** Containers run as non-root users (`USER appuser`) to prevent privilege escalation if a container is compromised.
*   **Image Signing:** Docker images are cryptographically signed using Cosign. The Kubernetes admission controller (Kyverno/OPA Gatekeeper) verifies the signature before allowing the pod to run.

### D. Continuous Deployment (CD)
*   **DAST (Dynamic Application Security Testing):**
    *   OWASP ZAP runs automated attacks against the staging API environments to find runtime vulnerabilities (XSS, Auth bypasses).
*   **Infrastructure Immutability:** Servers are never patched in place. If an update is required, new immutable images are built and deployed via Blue/Green or Canary strategies.

## 2. Secrets Management
*   **Zero Secrets in Code:** No `.env` files with production secrets are ever committed.
*   **Runtime Injection:** CI/CD runners and Production Pods retrieve secrets dynamically at runtime from AWS Secrets Manager or HashiCorp Vault using short-lived IAM roles (OIDC).

## 3. Threat Modeling & Penetration Testing
*   **Continuous Threat Modeling:** Performed during the design phase of every major new feature (e.g., Telemedicine Video, 3D Anatomy) using methodologies like STRIDE.
*   **Third-Party Pentesting:** Independent red teams conduct full-stack penetration testing annually and after major architectural changes.
*   **Bug Bounty Program:** Establish a public bug bounty program (e.g., HackerOne) to incentivize ethical hackers to report vulnerabilities.
