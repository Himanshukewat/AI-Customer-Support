package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.dto.AIService;
import com.aicustomersupport.springboot.dto.TicketAIRequest;
import com.aicustomersupport.springboot.dto.TicketAIResponse;
import com.aicustomersupport.springboot.entity.Ticket;
import com.aicustomersupport.springboot.repository.TicketRepository;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class TicketServiceTest {
    @Test
    void agentExceptionShouldSendTicketToHumanReview() {
        TicketRepository ticketRepository =
                Mockito.mock(TicketRepository.class);
        AIService aiService = Mockito.mock(AIService.class);
        AgentService agentService =
                Mockito.mock(AgentService.class);
        Ticket ticket = new Ticket();
        ticket.setTicketId("TEST-EXCEPTION");
        ticket.setDescription("I want to track my order");
        ticket.setOrderId(1013L);
        
        when(ticketRepository.save(any(Ticket.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        TicketAIResponse aiResponse = new TicketAIResponse();
        aiResponse.setCategory("ORDER");
        aiResponse.setSub_category("track_order");
        aiResponse.setSentiment("Neutral");
        aiResponse.setPriority("medium");
        aiResponse.setConfidence(0.95);

        when(aiService.analyzeTicket(any(TicketAIRequest.class)))
                .thenReturn(aiResponse);

        when(agentService.handleTicket("track_order", 1013L))
                .thenThrow(new RuntimeException("Simulated tool failure"));

        TicketService ticketService = new TicketService(
                ticketRepository,
                aiService,
                agentService
        );

        Ticket result = ticketService.createTicket(ticket);

        assertEquals("AI_COMPLETED", result.getAiStatus());
        assertEquals("HUMAN_REVIEW", result.getAiDecision());
        assertEquals("OPEN", result.getStatus());
        assertEquals(
                "Automated processing failed. Human review is required.",
                result.getResolution()
        );

        verify(ticketRepository, times(2)).save(any(Ticket.class));
    }
}
