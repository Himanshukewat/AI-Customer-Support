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

    public TicketService(TicketRepository ticketRepository,AIService aiService) {
        this.ticketRepository = ticketRepository;
        this.aiService = aiService;
    }

    public Ticket createTicket(Ticket ticket) {
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
        TicketAIResponse aiResponse = aiService.analyzeTicket(aiRequest);

        // store ai result in ticket

        savedTicket.setCategory(aiResponse.getCategory());
        savedTicket.setSubCategory(aiResponse.getSub_category());
        savedTicket.setSentiment(aiResponse.getSentiment());
        savedTicket.setPriority(aiResponse.getPriority());
        savedTicket.setAiConfidence(aiResponse.getConfidence());

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
