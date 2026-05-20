from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="EyeVerse AI Backend",
    description="WHO-compliant global AI eye health operating system API",
    version="1.0.0",
)

# CORS middleware for allowing cross-origin requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to EyeVerse AI Global Health API"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "EyeVerse AI"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
