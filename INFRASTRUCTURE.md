# GLOBAL EYE HEALTH ECOSYSTEM: CLOUD INFRASTRUCTURE & DEVOPS

This document outlines the production-ready infrastructure for the EyeVerse AI platform, designed for global scalability, high availability, and HIPAA/GDPR compliance.

## 1. Architecture Overview (Microservices)
The backend transitions from a monolithic BaaS (Supabase) to a Hybrid Microservices Architecture orchestrated via Kubernetes.

### Core Services (GoLang & Node.js/NestJS)
*   **Auth Service (GoLang):** Handles JWT issuance, OAuth2 (Google/Apple), Biometric session verification, and 2FA. High throughput, low latency.
*   **Clinical Data Service (NestJS):** Manages EHRs, Telemedicine scheduling, and HL7 FHIR integrations. Connects to PostgreSQL.
*   **AI Inference Service (Python/FastAPI):** Wraps custom TensorFlow/PyTorch models for remote inference (when edge-device MLKit/TFLite falls back). Requires GPU-enabled nodes.
*   **Community & Content Service (GoLang):** Handles the Reddit-style forums, video catalog, and article indexing. Backed by Elasticsearch for semantic search.
*   **Realtime Communication (Node.js/Socket.io):** Handles secure WebRTC signaling for telemedicine and encrypted chat.

## 2. Infrastructure as Code (Terraform)
We utilize Terraform to provision the entire stack on AWS (Primary) with GCP fallback for AI services.

*   **EKS (Elastic Kubernetes Service):** Orchestrates all microservices. Configured with Horizontal Pod Autoscalers (HPA) based on CPU and custom metrics (e.g., active WebRTC sessions).
*   **RDS (Relational Database Service) - PostgreSQL:** Multi-AZ deployment with Read Replicas in different geographic regions (US, EU, AP) to minimize latency for the Global Knowledge System.
*   **ElastiCache (Redis):** Handles session caching, rate limiting, and temporary leaderboards.
*   **S3 & CloudFront:** S3 stores all encrypted medical images, 3D anatomy GLB files, and video assets. CloudFront acts as the global CDN.

## 3. DevOps & CI/CD Pipeline (GitHub Actions)
The CI/CD pipeline enforces strict quality gates before any code reaches production.

### Frontend Pipeline (Flutter)
1.  **Code Analysis:** `dart analyze` and custom linting rules.
2.  **Testing:** Runs Unit, Widget, and Integration tests.
3.  **Build:** Compiles AAB/APK and IPA.
4.  **Security Scan:** Checks for hardcoded secrets and vulnerable dependencies.
5.  **Deployment (Fastlane):** Pushes to TestFlight (iOS) and Google Play Console (Android) Internal Tracks.
6.  **OTA Updates:** Pushes minor Dart code changes via Shorebird directly to user devices.

### Backend Pipeline (Microservices)
1.  **Lint & Test:** Runs Go/Node tests.
2.  **Containerize:** Builds Docker images and pushes to Amazon ECR.
3.  **Vulnerability Scan:** Scans Docker images using Trivy.
4.  **Deploy (ArgoCD):** Updates Kubernetes manifests in the staging environment. Once approved, promotes to production using Canary or Blue/Green deployment strategies.

## 4. Monitoring & Observability
*   **Prometheus & Grafana:** Monitors K8s node health, pod CPU/Memory, and custom business metrics (e.g., "Appointments booked per minute").
*   **ELK Stack (Elasticsearch, Logstash, Kibana):** Centralized logging. All logs are scrubbed of PII/PHI before ingestion.
*   **Sentry:** Tracks unhandled exceptions in the Flutter frontend and backend services, providing stack traces and release tracking.
*   **Firebase Crashlytics & Performance:** Native mobile crash reporting and startup time tracking.

## 5. Security & Compliance
*   **WAF (Web Application Firewall):** AWS WAF protects the API Gateway from DDoS attacks, SQL injection, and XSS.
*   **API Gateway:** Kong or AWS API Gateway handles rate limiting and JWT validation before routing to internal microservices.
*   **Secret Management:** AWS Secrets Manager injects database credentials and API keys directly into K8s pods at runtime. No secrets are stored in Git or `.env` files.
*   **Zero Trust Network:** Microservices communicate over mutual TLS (mTLS) using a service mesh (Istio).
