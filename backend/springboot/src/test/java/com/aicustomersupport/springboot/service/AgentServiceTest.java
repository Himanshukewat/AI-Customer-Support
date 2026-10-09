package com.aicustomersupport.springboot.service;

// import com.aicustomersupport.springboot.service.AgentResult;
// import com.aicustomersupport.springboot.service.AgentService;
// import com.aicustomersupport.springboot.service.ToolRegistry;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AgentServiceTest {

    @Test
    void unknownToolShouldRequireHumanReview() {
        ToolRegistry toolRegistry = new ToolRegistry(java.util.List.of());
        AgentService agentService = new AgentService(toolRegistry);
        AgentResult result = agentService.handleTicket(
                "unknown_intent",
                1013L
        );

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
        assertEquals(
                "No agent tool available for this request.",
                result.getMessage()
        );
    }
}