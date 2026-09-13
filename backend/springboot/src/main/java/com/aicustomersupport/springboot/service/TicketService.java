package com.aicustomersupport.springboot.service;

import java.util.*;

import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.repository.TicketRepository;
import com.aicustomersupport.springboot.entity.Ticket;



//“Ye class application ki business logic layer hai. Iska object Spring khud manage kare.”
@Service
public class TicketService {

    private final TicketRepository ticketRepository;

    public TicketService(TicketRepository ticketRepository) {
        this.ticketRepository = ticketRepository;
    }

    public Ticket createTicket(Ticket ticket) {
        return ticketRepository.save(ticket);
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
