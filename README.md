# ClearView MedOS

ClearView MedOS is a futuristic, state-of-the-art Medical Operating System designed for comprehensive eye health diagnostics, vision therapy, and general wellness. 

Built with Flutter and powered by a robust Python AI Backend, ClearView MedOS transitions the clinical experience from the hospital to the palm of your hand, ensuring military-grade HIPAA compliance through strictly enforced on-device database encryption and biometric security.

---

## 🌟 Key Features

### 1. Vision Therapy & Eye Gym
A suite of gamified clinical exercises designed to treat and prevent eye conditions:
- **MFBF Therapy (Amblyopia)**: Dichoptic red-cyan anaglyph games that force the brain to use both eyes simultaneously, effectively treating "lazy eye" and suppression.
- **Visual Perception**: Discrimination and visual memory puzzles that scale in difficulty to combat digital eye strain.
- **Blink Master (Edge AI)**: An on-device AI system that uses the front-facing camera to track blinks in real-time, preventing dry eye syndrome.
- **Focus Switch**: Near-far accommodative training.
- **Follow the Dot**: Smooth pursuit and saccadic tracking exercises.

### 2. Clinical Diagnostics
- **Amsler Grid**: Detect early signs of macular degeneration.
- **Snellen Chart**: Measure visual acuity.
- **Ishihara Test**: Check for color blindness.
- **AI Symptom Checker**: A smart symptom routing system that flags emergency conditions like Acute Glaucoma.

### 3. General Health Expansion
- **Medi Wiki**: A searchable, real-time index of eye conditions, wellness techniques (like the 20-20-20 rule), and treatments.
- **AI Health Chatbot**: An NLP-powered medical chatbot connected to the local Python backend, capable of interpreting symptoms and dispensing immediate guidance.

### 4. Enterprise-Grade Security
- **Biometric Locking**: The entire OS is locked behind a `local_auth` wall, requiring FaceID or Fingerprint to view patient records.
- **Database Encryption**: All SQLite data is encrypted at rest using AES-256 via `sqflite_sqlcipher` and `flutter_secure_storage`.

---

## 🛠️ Tech Stack

- **Frontend Application**: Flutter (Dart)
- **Local Database**: SQLCipher (Encrypted SQLite)
- **Edge AI Processing**: Google MLKit (Face/Blink Detection)
- **Deep Learning Backend**: Python (FastAPI, PyTorch/TensorFlow)

---

## 🚀 Setup & Installation

Because ClearView MedOS utilizes a local Python Engine for advanced AI tasks, you must run both the Flutter app and the Python server.

### 1. Start the Python AI Engine
```bash
cd python_ai_backend
pip install -r requirements.txt
python main.py
```
*The server will start locally on `http://localhost:8000`.*

### 2. Run the Flutter App
Ensure you have a simulator running or a physical device connected.
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔮 Future Aspects & Roadmap

The vision for ClearView MedOS extends far beyond its current capabilities:

1. **Eye-Gaze Controlled OS (Hardware Integration)**
   - Integrating deep hardware eye-tracking (similar to Tobii or SpecialEffect's software) so paralyzed or physically disabled users can navigate the entire Flutter application purely via eye gaze.
2. **Deep Learning Retinal Analysis**
   - Expanding the Python FastAPI backend to process physical fundus camera images via PyTorch ResNet models, returning Grad-CAM heatmaps showing exact locations of Diabetic Retinopathy or Glaucoma damage.
3. **EHR / FHIR Synchronization**
   - Seamlessly syncing the local SQLCipher database to remote hospital servers using the standard HL7 FHIR protocols, allowing ophthalmologists to monitor patient therapy compliance remotely.
4. **Photoplethysmography (PPG) Vitals**
   - Using the smartphone camera to detect micro-fluctuations in facial skin color to accurately measure heart rate and blood pressure as part of the General Health Expansion.

---
*Built for the future of decentralized medicine.*

## 📄 License & Legal

ClearView Hub is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

For information on contributing, security policies, and our code of conduct, please see:
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
