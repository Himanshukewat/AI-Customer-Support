from pydantic import BaseModel


# Spring Boot jab Python ko ticket bhejega, Python ko pata hona chahiye ki ticket mein kaun-kaun si information expected hai
class TicketRequest(BaseModel):
    ticket_id: str
    user_id: int
    order_id: str
    description: str

