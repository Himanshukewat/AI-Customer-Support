package com.aicustomersupport.springboot.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data 
public class Ticket {
    @Id 
    // Auto-generate the ID for each ticket
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String ticketId;
    private Long userId;
    private Long orderId;

    private String category;
    private String subCategory;
    private String priority;
    private String status;
    private String sentiment;

    private String description;

    private String assignedTo;
    private Double aiConfidence;
    private String aiStatus;
    private String aiDecision;
    private String resolution;

    
}
