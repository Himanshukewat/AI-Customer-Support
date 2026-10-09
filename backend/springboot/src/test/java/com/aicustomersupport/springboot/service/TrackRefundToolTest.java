package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Refund;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class TrackRefundToolTest {

    private RefundService refundService;
    private TrackRefundTool trackRefundTool;

    @BeforeEach
    void setUp() {
        refundService = mock(RefundService.class);
        trackRefundTool = new TrackRefundTool(refundService);
    }

    @Test
    void shouldReturnRefundDetailsWhenRefundExists() {
        Refund refund = new Refund();
        refund.setStatus("PROCESSING");
        refund.setAmount("799.0");

        when(refundService.getRefundByOrderId("1012"))
                .thenReturn(refund);

        AgentResult result = trackRefundTool.execute(1012L);

        assertTrue(result.isSuccess());
        assertFalse(result.isRequiresHuman());
        assertTrue(result.getMessage().contains("PROCESSING"));
    }

    @Test
    void shouldRequireHumanWhenOrderIdIsMissing() {
        AgentResult result = trackRefundTool.execute(null);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
        verifyNoInteractions(refundService);
    }

    @Test
    void shouldRequireHumanWhenRefundDoesNotExist() {
        when(refundService.getRefundByOrderId("9999"))
                .thenReturn(null);

        AgentResult result = trackRefundTool.execute(9999L);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
    }

    @Test
    void shouldUseCorrectToolName() {
        assertEquals("track_refund", trackRefundTool.getName());
    }
}
