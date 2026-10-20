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
    private final TeamRoutingService teamRoutingService;

    public TicketService(TicketRepository ticketRepository,
        AIService aiService,
        AgentService agentService,
        TeamRoutingService teamRoutingService) {
        this.ticketRepository = ticketRepository;
        this.aiService = aiService;
        this.agentService = agentService;
        this.teamRoutingService = teamRoutingService;
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
        if (aiResponse.getConfidence() >= CONFIDENCE_THRESHOLD) {
            savedTicket.setAssignedTeam(
                    teamRoutingService.getTeam(aiResponse.getCategory())
            );
        } else {
            savedTicket.setAssignedTeam("GENERAL_SUPPORT");
        }     
        savedTicket.setSubCategory(aiResponse.getSub_category());
        savedTicket.setSentiment(aiResponse.getSentiment());
        savedTicket.setPriority(aiResponse.getPriority());
        savedTicket.setAiConfidence(aiResponse.getConfidence());
        
        savedTicket.setAiStatus("AI_COMPLETED");

        String intent = savedTicket.getSubCategory();

        boolean automationAllowed  = "track_order".equalsIgnoreCase(intent)
         || "track_refund".equalsIgnoreCase(intent) 
         || "check_invoice".equalsIgnoreCase(intent);

        if(aiResponse.getConfidence() >= CONFIDENCE_THRESHOLD 
        && automationAllowed){
            try{
                AgentResult agentResult = agentService.handleTicket(
                        intent,
                        savedTicket.getOrderId()
                );
                savedTicket.setResolution(agentResult.getMessage());
                if(agentResult.isSuccess()) {
                    savedTicket.setAiDecision("AUTO_HANDLED");
                    savedTicket.setStatus("RESOLVED");
                }else{
                    savedTicket.setAiDecision("HUMAN_REVIEW");
                    savedTicket.setStatus("OPEN");
                }
            }catch(Exception e){
                System.out.println(
                        "Agent tool execution failed: " + e.getMessage()
                );
                savedTicket.setAiDecision("HUMAN_REVIEW");
                savedTicket.setStatus("OPEN");
                savedTicket.setResolution(
                        "Automated processing failed. Human review is required."
                );
            }
        } else {
            savedTicket.setAiDecision("HUMAN_REVIEW");
            savedTicket.setStatus("OPEN");
            savedTicket.setResolution(
                    "This request requires human review."
            );
        }
        } catch (Exception e) {
            System.out.println("AI service call failed:" + e.getMessage());
            savedTicket.setAiStatus("AI_FAILED");
            savedTicket.setAiDecision("HUMAN_REVIEW");
            savedTicket.setStatus("OPEN");
            savedTicket.setResolution(
                    "AI service failed. Human review is required."
            );
        }
        return ticketRepository.save(savedTicket);
    }

    public List<Ticket> getAllTickets() {
        return ticketRepository.findAll();
    }

    public List<Ticket> getHumanReviewTickets() {
        System.out.println("HUMAN REVIEW ENDPOINT CALLED");
        List<Ticket> tickets = ticketRepository.findByAiDecision("HUMAN_REVIEW");
        System.out.println("HUMAN REVIEW COUNT: " + tickets.size());
        return tickets;
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

    /**
    * 
    * Ticket nahi mila
            → null

        AI decision HUMAN_REVIEW nahi
            → assign nahi hoga

        HUMAN_REVIEW
            → assignedTo set
            → status = IN_PROGRESS
            → DB save
     */

    public Ticket assignTicket(Long id, String assignedTo){
        Ticket ticket = ticketRepository.findById(id).orElse(null);
        if(ticket == null){
            return null;
        }
        if(!"HUMAN_REVIEW".equalsIgnoreCase(ticket.getAiDecision())){
            return null;
        }

        ticket.setAssignedTo(assignedTo);
        ticket.setStatus("IN_PROCESS");

        return ticketRepository.save(ticket);
    }

    public Ticket resolveTicket(Long id, String resolution) {
        Ticket ticket = ticketRepository.findById(id).orElse(null);
        if (ticket == null) {
            return null;
        }
        if (!"IN_PROCESS".equalsIgnoreCase(ticket.getStatus())) {
            return null;
        }
        ticket.setResolution(resolution);
        ticket.setStatus("RESOLVED");
        return ticketRepository.save(ticket);
    }

    
    public Ticket approveCancellation(Long id) {
        Ticket ticket = ticketRepository.findById(id).orElse(null);
        if (ticket == null) {
            return null;
        }
        if (!"HUMAN_REVIEW".equalsIgnoreCase(ticket.getAiDecision())
                || !"cancel_order".equalsIgnoreCase(ticket.getSubCategory())
                || !"OPEN".equalsIgnoreCase(ticket.getStatus())) {
            return null;
        }
        if (ticket.getOrderId() == null) {
            return null;
        }
        AgentResult result = agentService.handleTicket(
                "cancel_order",
                ticket.getOrderId()
        );
        ticket.setResolution(result.getMessage());
        if (result.isSuccess()) {
            ticket.setAiDecision("HUMAN_APPROVED");
            ticket.setStatus("RESOLVED");
        } else {
            ticket.setAiDecision("HUMAN_APPROVED");
            ticket.setStatus("OPEN");
        }
        return ticketRepository.save(ticket);
    }

    public Ticket rejectCancellation(Long id) {
        Ticket ticket = ticketRepository.findById(id).orElse(null);
        if (ticket == null) {
            return null;
        }
        if (!"HUMAN_REVIEW".equalsIgnoreCase(ticket.getAiDecision())
                || !"cancel_order".equalsIgnoreCase(ticket.getSubCategory())
                || !"OPEN".equalsIgnoreCase(ticket.getStatus())) {
            return null;
        }
        ticket.setAiDecision("HUMAN_REJECTED");
        ticket.setStatus("RESOLVED");
        ticket.setResolution("Cancellation rejected by human agent.");
        return ticketRepository.save(ticket);
    }
}
