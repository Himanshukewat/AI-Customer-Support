package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Component;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component 
public class ToolRegistry {
    private final Map<String, AgentTool> tools;

     public ToolRegistry(List<AgentTool> agentTools) {

        this.tools = agentTools.stream()
                .collect(Collectors.toMap(
                        AgentTool::getName,
                        Function.identity()
                ));
    }

    public AgentTool getTool(String toolName) {
        return tools.get(toolName);
    }

    
}
