import subprocess
import time
import os

def run_backends():
    print("🚀 Starting ClearView Hub Backends...")
    
    # Paths to backends
    ai_backend_dir = r"C:\Users\jmrsai\StudioProjects\clearview_hub\python_ai_backend"
    telemetry_backend_dir = r"C:\Users\jmrsai\StudioProjects\clearview_hub\python_backend"
    
    # Commands to run
    # AI Backend on 8000
    ai_cmd = ["python", "main.py"]
    # Telemetry Backend on 8001
    telemetry_cmd = ["python", "app.py"]
    
    print(f"📡 Starting AI Brain on port 8000...")
    ai_process = subprocess.Popen(ai_cmd, cwd=ai_backend_dir)
    
    print(f"📡 Starting Telemetry Engine on port 8001...")
    telemetry_process = subprocess.Popen(telemetry_cmd, cwd=telemetry_backend_dir)
    
    try:
        while True:
            time.sleep(1)
            if ai_process.poll() is not None:
                print("❌ AI Brain stopped unexpectedly.")
                break
            if telemetry_process.poll() is not None:
                print("❌ Telemetry Engine stopped unexpectedly.")
                break
    except KeyboardInterrupt:
        print("\n🛑 Stopping backends...")
        ai_process.terminate()
        telemetry_process.terminate()
        print("✅ Done.")

if __name__ == "__main__":
    run_backends()
