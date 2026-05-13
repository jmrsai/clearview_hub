# Copyright 2026 ClearView Hub Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import cv2
import mediapipe as mp
import numpy as np
from pydantic import BaseModel
import uvicorn

app = FastAPI(
    title="ClearView Hub - AI Telemetry Engine",
    description="Python backend for advanced ophthalmological telemetry and gaze analysis.",
    version="1.0.0"
)

# Enable CORS for Flutter web/app communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize MediaPipe Face Mesh for eye landmark detection
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True, # Critical for iris/pupil detection
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)

class TelemetryResponse(BaseModel):
    status: str
    left_eye_openness: float
    right_eye_openness: float
    gaze_direction: str

@app.get("/")
def read_root():
    return {"message": "ClearView Hub AI Engine is running."}

@app.post("/analyze-frame", response_model=TelemetryResponse)
async def analyze_frame(file: UploadFile = File(...)):
    """
    Receives a video frame from the Flutter app and calculates 
    Eye Aspect Ratio (EAR) and Gaze Direction using MediaPipe.
    """
    try:
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if img is None:
            raise HTTPException(status_code=400, detail="Invalid image file.")

        # Convert the BGR image to RGB before processing.
        results = face_mesh.process(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))

        if not results.multi_face_landmarks:
            return TelemetryResponse(
                status="no_face_detected",
                left_eye_openness=0.0,
                right_eye_openness=0.0,
                gaze_direction="unknown"
            )

        landmarks = results.multi_face_landmarks[0].landmark

        # Placeholder for EAR calculation logic. 
        # In a full implementation, you would use specific landmark indices 
        # (e.g., 386, 374 for right eye, 159, 145 for left eye) to calculate openness.
        left_ear = 0.85 # Simulated value
        right_ear = 0.84 # Simulated value
        
        # Placeholder for Gaze estimation using Iris landmarks
        gaze = "center" # Simulated value

        return TelemetryResponse(
            status="success",
            left_eye_openness=left_ear,
            right_eye_openness=right_ear,
            gaze_direction=gaze
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8001, reload=True)
