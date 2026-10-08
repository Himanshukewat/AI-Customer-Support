package com.aicustomersupport.springboot.repository;

import java.util.*;
import com.aicustomersupport.springboot.entity.Ticket;
import org.springframework.data.jpa.repository.JpaRepository;


// This interface extends JpaRepository to provide CRUD operations for the Ticket entity.
// Ticket → kis entity/table ke saath kaam karna hai
// Long   → Ticket ka primary-key type
public interface TicketRepository extends JpaRepository<Ticket, Long> {
    List<Ticket> findByAiDecision(String aiDecision);
}