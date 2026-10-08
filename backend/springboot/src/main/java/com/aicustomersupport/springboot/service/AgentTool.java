package com.aicustomersupport.springboot.service;

public interface AgentTool {

    /*
    getName() → "track_order"
    execute() → order status
     */
    
    String getName();
    AgentResult execute(Long orderId);
}
