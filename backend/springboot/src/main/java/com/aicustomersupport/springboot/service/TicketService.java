package com.aicustomersupport.springboot.service;

import java.util.*;

import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.repository.TicketRepository;
import com.aicustomersupport.springboot.dto.AIService;
import com.aicustomersupport.springboot.dto.TicketAIRequest;
import com.aicustomersupport.springboot.dto.TicketAIResponse;
import com.aicustomersupport.springboot.entity.Ticket;



//“Ye class application ki business logic layer hai. Iska object Spring khud manage kare.”
@Service
public class TicketService {

    private final TicketRepository ticketRepository;
    private final AIService aiService;
    private static final double CONFIDENCE_THRESHOLD = 0.80;
    private final AgentService agentService;

    public TicketService(TicketRepository ticketRepository,AIService aiService, AgentService agentService) {
        this.ticketRepository = ticketRepository;
        this.aiService = aiService;
        this.agentService = agentService;
    }

    public Ticket createTicket(Ticket ticket) {
        ticket.setAiStatus("AI_PENDING");
        Ticket savedTicket = ticketRepository.save(ticket);
        // prepare ai servicw

        TicketAIRequest aiRequest = new TicketAIRequest();

        aiRequest.setTicket_id(savedTicket.getTicketId());
        aiRequest.setUser_id(savedTicket.getUserId());

        if(savedTicket.getOrderId() != null){
            aiRequest.setOrder_id(String.valueOf(savedTicket.getOrderId()));
        }

        aiRequest.setDescription(savedTicket.getDescription());

        // send ticket to ai srvice
        try {
        TicketAIResponse aiResponse = aiService.analyzeTicket(aiRequest);

        // store ai result in ticket

        savedTicket.setCategory(aiResponse.getCategory());
        savedTicket.setSubCategory(aiResponse.getSub_category());
        savedTicket.setSentiment(aiResponse.getSentiment());
        savedTicket.setPriority(aiResponse.getPriority());
        savedTicket.setAiConfidence(aiResponse.getConfidence());
        
        savedTicket.setAiStatus("AI_COMPLETED");

        if (aiResponse.getConfidence() >= CONFIDENCE_THRESHOLD) {
                savedTicket.setAiDecision("AUTO_HANDLED");
                String agentResult = agentService.handleTicket(
                    savedTicket.getSubCategory(),
                    savedTicket.getOrderId()
            );
            savedTicket.setResolution(agentResult);
        } else {
            savedTicket.setAiDecision("HUMAN_REVIEW");
      }
        } catch (Exception e) {
            System.out.println("AI service call failed:" + e.getMessage());
            savedTicket.setAiStatus("AI_FAILED");
        }

        return ticketRepository.save(savedTicket);
    }

    public List<Ticket> getAllTickets() {
        return ticketRepository.findAll();
    }


    public Ticket getTicketById(Long id) {
        return ticketRepository.findById(id).orElse(null);
    }

    public Ticket updateTicket(Long id, Ticket updatedTicket) {
        Ticket oldTicket = ticketRepository.findById(id).orElse(null);
        if(oldTicket != null) {
            oldTicket.setUserId(updatedTicket.getUserId());
            oldTicket.setOrderId(updatedTicket.getOrderId());
            oldTicket.setCategory(updatedTicket.getCategory());
            oldTicket.setSubCategory(updatedTicket.getSubCategory());
            oldTicket.setPriority(updatedTicket.getPriority());
            oldTicket.setStatus(updatedTicket.getStatus());
            oldTicket.setSentiment(updatedTicket.getSentiment());
            oldTicket.setDescription(updatedTicket.getDescription());
            oldTicket.setAssignedTo(updatedTicket.getAssignedTo());
            oldTicket.setAiConfidence(updatedTicket.getAiConfidence());
            oldTicket.setResolution(updatedTicket.getResolution());
            return ticketRepository.save(oldTicket);
        }
        return null;
    }


    public void deleteTicket(Long id) {
        ticketRepository.deleteById(id);
    } 
}
