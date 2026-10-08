package com.aicustomersupport.springboot.service;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor  
public class AgentResult {
    private boolean success;
    private boolean requiresHuman;
    private String message;
}
