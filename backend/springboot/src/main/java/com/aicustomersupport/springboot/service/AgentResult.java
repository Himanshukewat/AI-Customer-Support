package com.aicustomersupport.springboot.service;

import lombok.Data;

@Data
public class AgentResult {
    private boolean success;
    private boolean requiresHuman;
    private String message;

    public AgentResult(boolean success, boolean requiresHuman, String message) {
        this.success = success;
        this.requiresHuman = requiresHuman;
        this.message = message;
    }
}
