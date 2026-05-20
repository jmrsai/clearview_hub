# How to Run ClearView Hub

This document provides instructions on how to set up and run the ClearView Hub application.

## Project Architecture

The ClearView Hub system consists of three main components:

1.  **Flutter Application:** The main application, located in the root of this project.
2.  **AI Backend:** A Python-based backend for AI-related features, located in the `python_ai_backend` directory.
3.  **Telemetry Backend:** A Python-based backend for telemetry data, located in the `python_backend` directory.

To run the application with full functionality, you must have all three components running.

## Setup Instructions

### 1. Flutter Application

1.  **Install Flutter:** If you haven't already, install the Flutter SDK by following the official documentation.
2.  **Install Dependencies:** Open a terminal in the root of the project and run:
    ```bash
    flutter pub get
    ```

### 2. Python Backends

**IMPORTANT:** The Python backends require a **64-bit** version of Python. We recommend using Python 3.11. You can download it from the official Python website.

1.  **Telemetry Backend:**
    *   Open a terminal in the `python_backend` directory.
    *   Install the dependencies:
        ```bash
        pip install -r requirements.txt
        ```

2.  **AI Backend:**
    *   Open a terminal in the `python_ai_backend` directory.
    *   Install the dependencies:
        ```bash
        pip install -r requirements.txt
        ```
    *   **Troubleshooting:** If the installation fails for the `tensorflow-cpu` package, it is likely due to an incompatible Python environment. Please ensure you are using a 64-bit version of Python 3.11.

## Running the Application

1.  **Start the Backends:**
    *   Open a terminal in the root of the project.
    *   Run the `run_backends.py` script to start both the AI and Telemetry backends:
        ```bash
        python run_backends.py
        ```
    *   This will start the two backend servers in separate terminal windows. Keep these windows open.

2.  **Run the Flutter App:**
    *   Open a new terminal in the root of the project.
    *   Run the Flutter application:
        ```bash
        flutter run
        ```

## Building the Android APK

To build a release version of the Android application (APK), run the following command from the root of the project:

```bash
flutter build apk --release
```

The APK file will be located in `build/app/outputs/flutter-apk/app-release.apk`.
