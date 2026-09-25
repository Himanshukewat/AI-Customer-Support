from pathlib import Path

import joblib
from fastapi import FastAPI

from app.models.ticket import TicketRequest
from app.models.analysis import TicketAnalysisResponse

app = FastAPI()

#Project root
BASE_DIR = Path(__file__).resolve().parents[1]

#Load trained models

MODEL_DIR = BASE_DIR / "ml" / "models"

category_model = joblib.load(MODEL_DIR / "category_model.pkl")
intent_model =  joblib.load(MODEL_DIR / "intent_model.pkl")


@app.get("/")
def home():
    return {"message": "AI Service is running"}


@app.post("/analyze-ticket", response_model=TicketAnalysisResponse)
def analyze_ticket(ticket: TicketRequest):

    #predict category
    category = category_model.predict(
        [ticket.description]
    )[0]


    # get intent model for predicted category
    model = intent_model[category]

    # predict intent + confidence

    if isinstance(model, str):
        intent = intent_model
        confidence = 1.0
    else:
        intent = model.predict(
            [ticket.description]
        )[0]

        probabilities = model.predict_proba(
            [ticket.description]
        )[0]


        classes = model.classes_

        confidence = probabilities[
            list(classes).index(intent)
        ]
            

    return {
        "category": category,
        "sub_category": intent,
        "sentiment": "",
        "priority": "",
        "confidence": float(confidence)
    }