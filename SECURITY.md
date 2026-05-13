# Security Policy

## Supported Versions

We provide security updates for the following versions of ClearView Hub:

| Version | Supported          |
| ------- | ------------------ |
| 2.0.x   | :white_check_mark: |
| < 2.0.0 | :x:                |

## Reporting a Vulnerability

As ClearView Hub handles sensitive medical data, we take security extremely seriously. We are committed to maintaining military-grade HIPAA compliance.

If you discover a security vulnerability, please do NOT open a public issue. Instead, follow these steps:

1. Email your findings to security@clearviewhub.example.com (Placeholder).
2. Include a detailed description of the vulnerability and steps to reproduce.
3. We will acknowledge your report within 48 hours and provide a timeline for a fix.

## Security Practices
- **Encryption**: All patient data is encrypted at rest using AES-256 via SQLCipher.
- **Authentication**: Biometric locking is required for all clinical modules.
- **Privacy**: No patient data is transmitted to external servers unless explicitly configured via FHIR synchronization.
