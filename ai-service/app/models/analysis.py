from pydantic import BaseModel

# when Python AI model will analyze the ticket, it will return this response to Spring Boot
class TicketAnalysisResponse(BaseModel):
    category: str
    sub_category: str
    sentiment: str
    priority: str
    confidence: float