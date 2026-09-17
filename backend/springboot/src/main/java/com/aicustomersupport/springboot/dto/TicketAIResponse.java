package com.aicustomersupport.springboot.dto;

import lombok.Data;

@Data
public class TicketAIResponse {
    private String category;
    private String sub_category;
    private String sentiment;
    private String priority;
    private Double confidence;
}


// use for specific data to ai wants