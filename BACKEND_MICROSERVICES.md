# BACKEND MICROSERVICES & API ARCHITECTURE

This document defines the transition from a monolithic architecture to a scalable, enterprise-grade Microservices Architecture for the Global Eye Health Ecosystem.

## 1. Core Principles
*   **API Gateway Pattern:** All external client requests pass through an API Gateway (e.g., Kong). The gateway handles rate-limiting, JWT validation, and routes requests to the appropriate internal microservice.
*   **gRPC for Inter-Service Communication:** Microservices communicate internally using gRPC (Protobuf) for high performance and strict type safety, avoiding the overhead of HTTP/JSON.
*   **Database per Service:** Each microservice manages its own database schema to prevent tight coupling.
*   **Event-Driven Architecture:** Asynchronous tasks (like AI processing or email notifications) are handled via message brokers (Apache Kafka or RabbitMQ).

## 2. Microservice Definitions

### A. Authentication & Identity Service (GoLang)
*   **Responsibility:** User registration, login (Email, OAuth2), MFA, session management, and RBAC token generation.
*   **Tech Stack:** GoLang, Redis (Sessions), PostgreSQL (User Credentials).
*   **Key APIs:**
    *   `POST /auth/register`
    *   `POST /auth/login`
    *   `POST /auth/refresh`
    *   `POST /auth/mfa/verify`

### B. Clinical Data & EHR Service (NestJS)
*   **Responsibility:** Managing patient medical records, eye test results, and HL7 FHIR compliance mapping.
*   **Tech Stack:** Node.js (NestJS), PostgreSQL, AWS S3 (for medical imaging).
*   **Key APIs:**
    *   `GET /clinical/patients/{id}/records`
    *   `POST /clinical/tests/results`
    *   `PUT /clinical/patients/{id}/history`

### C. Telemedicine & Scheduling Service (GoLang)
*   **Responsibility:** Doctor availability management, appointment booking, and WebRTC signaling for video consultations.
*   **Tech Stack:** GoLang, Redis (Live Availability Cache), PostgreSQL.
*   **Key APIs:**
    *   `GET /telemedicine/doctors?specialty=glaucoma`
    *   `POST /telemedicine/appointments/book`
    *   `WS /telemedicine/signaling` (WebSocket for WebRTC)

### D. Community & Knowledge Service (Node.js)
*   **Responsibility:** Managing the Reddit-style forums, verified medical articles, and video catalogs.
*   **Tech Stack:** Node.js (Express), Elasticsearch (Semantic Search), PostgreSQL.
*   **Key APIs:**
    *   `GET /knowledge/search?q=dry+eyes`
    *   `GET /community/groups/{slug}/feed`
    *   `POST /community/posts`

### E. AI Inference & Processing Service (Python)
*   **Responsibility:** Heavy AI lifting that cannot be done on the edge device. Analyzes retina scans for diabetic retinopathy, processes OCR for prescriptions, and generates article summaries.
*   **Tech Stack:** Python (FastAPI), PyTorch/TensorFlow, RabbitMQ (for task queuing).
*   **Key APIs:**
    *   `POST /ai/analyze-retina` (Requires multipart/form-data)
    *   `POST /ai/ocr-prescription`

## 3. Deployment Strategy (Kubernetes)
*   Each microservice is containerized via **Docker**.
*   Deployed to an **EKS Cluster** using **Helm Charts**.
*   **Horizontal Pod Autoscaling (HPA)** scales the Telemedicine and AI Inference services based on CPU/Memory pressure during peak hours.

## 4. GraphQL Integration (Optional/Future)
To optimize data fetching for the Flutter mobile client (reducing over-fetching), we will introduce a **GraphQL Federation/Gateway** layer (e.g., Apollo Router) sitting behind the API Gateway. This allows the mobile app to query Clinical Data, Community Posts, and AI Recommendations in a single round-trip.
