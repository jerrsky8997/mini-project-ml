from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Schema Request
class PredictRequest(BaseModel):
    feature_1: float
    feature_2: str

# Schema Response
class PredictResponse(BaseModel):
    prediction_result: str
    confidence_score: float

# Endpoint GET /health
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Service is running gracefully"}

# Endpoint POST /api/v1/predict
@app.post("/api/v1/predict", response_model=PredictResponse)
def predict(data: PredictRequest):
    try:
        # Simulasi proses prediksi machine learning
        if data.feature_1 < 0:
            raise ValueError("Feature 1 tidak boleh negatif")
            
        hasil_prediksi = f"Kategori {data.feature_2.upper()}"
        skor = 0.95
        
        return PredictResponse(
            prediction_result=hasil_prediksi,
            confidence_score=skor
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error")