# GLOBAL MEDICAL EYE HEALTH ECOSYSTEM: ARCHITECTURE & ROADMAP

This document outlines the architectural strategy and execution roadmap for transforming ClearView Hub into the world's most advanced, free, AI-powered Medical Eye Health Ecosystem.

## 1. Cloud Infrastructure & Hosting
**Multi-Cloud Strategy for Global Scale & Resilience**
*   **Primary Database & Auth:** **Supabase (PostgreSQL)**. Provides relational integrity for EHRs (Electronic Health Records), HIPAA-ready Row Level Security (RLS), and Edge Functions for lightweight AI processing.
*   **Analytics & Push Notification Edge:** **Firebase**. Utilized strictly for Crashlytics, Firebase Cloud Messaging (FCM) for global appointment/medication reminders, and App Check for API abuse prevention.
*   **CDN & Content Delivery:** **Cloudflare**. Caching medical video assets and 3D models at the edge to ensure high-speed access globally, particularly in low-bandwidth rural areas.
*   **Deployment:** **GitHub Actions + Codemagic (or Fastlane)**. Fully automated CI/CD pipeline. Every PR triggers automated integration tests, accessibility audits, and upon merge, automates OTA (Over-The-Air) updates via Shorebird for immediate patching without app store delays.

## 2. API Architecture & Auto-Content Updates
**The "Internet-Powered Medical Knowledge Engine"**
*   **Cron-Triggered Edge Functions:** Supabase Edge functions run nightly to fetch data from trusted APIs (WHO, PubMed, ClinicalTrials.gov).
*   **AI Summarization Pipeline:** Fetched articles are passed through an LLM (e.g., Gemini Pro) to generate accessible, patient-friendly summaries.
*   **Strict Verification Gate:** Imported content defaults to `is_verified = false`. It enters a moderation queue where verified doctors (identified via `profiles.role = 'doctor'`) approve the content before it goes live.
*   **Semantic Search:** Medical articles are converted into vector embeddings using `pgvector` in Supabase. When a user searches for "blurry vision morning", the app performs a semantic similarity search, surfacing the most medically relevant articles, verified community posts, and nearby specialists simultaneously.

## 3. 3D Learning Architecture & Video System
*   **3D Infrastructure:** Integration of the `flutter_3d_controller` or an embedded Unity view (via `flutter_unity_widget`) for complex anatomical rendering (e.g., interactive retina models).
*   **Asset Management:** 3D GLB/GLTF models and High-Resolution Medical Videos are stored in Supabase Storage buckets, fronted by Cloudflare.
*   **Adaptive Video Streaming:** Implementing HLS (HTTP Live Streaming) via the `video_player` package. The app automatically degrades video quality for rural users on 3G networks to ensure uninterrupted education.

## 4. Security & Healthcare Compliance (HIPAA/GDPR)
*   **Encryption at Rest:** Local patient data (Hive/Isar) is encrypted using AES-256 via `flutter_secure_storage`.
*   **Encryption in Transit:** All Dio network requests are enforced over TLS 1.3 with certificate pinning.
*   **Row Level Security (RLS):** Strict PostgreSQL policies ensure a patient's medical records can *only* be queried if `auth.uid() = patient_id` OR if a verified `doctor_id` is explicitly granted access in a junction table.
*   **Audit Logging:** Every `SELECT` on a sensitive medical record triggers a Postgres function that writes to a `HIPAA_audit_log` table, immutable and time-stamped.

## 5. Accessibility Improvements (A11y-First Design)
*   **Semantics:** Every custom widget is wrapped in `Semantics` nodes with clear labels, hints, and values optimized for TalkBack (Android) and VoiceOver (iOS).
*   **Dyslexia Mode:** Centralized Riverpod provider (`dyslexiaModeProvider`) dynamically switches the entire app's `TextTheme` to use specialized fonts (e.g., Lexend or OpenDyslexic), increasing letter-spacing and line-height.
*   **High Contrast & Scalability:** UI elements use `MediaQuery` and `LayoutBuilder` to ensure flawless rendering even when the OS text scale factor is set to 200%. Colors adhere strictly to WCAG AAA contrast ratios.

## 6. Open Source & Monetization Strategy
*   **The "Free for Patients" Promise:** The core educational, AI screening, and community tools remain 100% free and open-source to democratize eye health globally.
*   **Monetization via Entrepreneur Hub (B2B SaaS):** Revenue is generated through the Entrepreneur Hub. Clinics and startups pay for "Pro" or "Enterprise" tiers (managed via RevenueCat) to access:
    *   Advanced CRM and Appointment Scheduling.
    *   AI-driven local market analytics (e.g., "Trending eye symptoms in your zip code").
    *   Premium listing placements in the Doctor/Clinic search engine.
*   **Data Licensing (Opt-In & Anonymized):** Aggregated, strictly anonymized epidemiological data (e.g., regional spikes in digital eye strain) can be licensed to research institutions and NGOs.

## 7. Future Roadmap (The Next 5 Years)
*   **Year 1: Global Foundation.** Complete the Flutter multi-platform rollout (iOS, Android, Web). Finalize the Semantic Search and verified Medical Article pipelines.
*   **Year 2: Hardware Integrations.** Release official SDKs for Wearables. Integrate with Apple Watch/Samsung Galaxy Watch to correlate heart rate variability with eye strain and screen time.
*   **Year 3: Spatial Computing.** Launch the native Apple Vision Pro and Meta Quest versions of the 3D learning platform, allowing medical students to perform "virtual dissections" of the human eye.
*   **Year 4: Predictive AI.** Upgrade the `AiVisionService` to a sophisticated, federated learning model that can predict the onset of conditions like Diabetic Retinopathy based on subtle, long-term changes in a user's local vision tests.
*   **Year 5: Brain-Computer Interfaces.** Partner with BCI manufacturers to allow severely visually impaired or paralyzed users to navigate the ecosystem entirely via neural intent or advanced gaze tracking.
