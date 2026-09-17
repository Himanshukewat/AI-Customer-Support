package com.aicustomersupport.springboot.dto;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Service 
public class AIService {
    private final RestClient restClient;

    public AIService(){
        this.restClient = RestClient.builder()
                .baseUrl("http://localhost:8000")
                .build();
    }


    public TicketAIResponse analyzeTicket(TicketAIRequest request) {

        return restClient.post()
                .uri("/analyze-ticket")
                .contentType(MediaType.APPLICATION_JSON)
                .body(request)
                .retrieve()
                .body(TicketAIResponse.class);
    }

}


/**
 * Spring Boot
     │
     │ POST
     ▼
http://localhost:8000/analyze-ticket
     │
     ▼
FastAPI
     │
     ▼
TicketAIResponse
 */