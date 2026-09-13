from fastapi import FastAPI
from app.models.ticket import TicketRequest
from app.models.analysis import TicketAnalysisResponse

app = FastAPI()


@app.get("/")
def home():
    return {"message": "AI Service is running"}


@app.post("/analyze-ticket", response_model=TicketAnalysisResponse)
def analyze_ticket(ticket: TicketRequest):
    return {
        "category": "Delivery",
        "sub_category": "Late Delivery",
        "sentiment": "Frustrated",
        "priority": "High",
        "confidence": 0.91
    }