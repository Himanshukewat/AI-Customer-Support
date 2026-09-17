package com.aicustomersupport.springboot.dto;

import lombok.Data;

@Data
public class TicketAIRequest {

    private String ticket_id;
    private Long user_id;
    private String order_id;
    private String description;
}