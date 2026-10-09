package com.aicustomersupport.springboot.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CancelOrderToolTest {

    @Test
    void successfulCancellationShouldBeAutoHandled() {

        OrderService orderService = mock(OrderService.class);

        when(orderService.cancelOrder("1013"))
                .thenReturn("Order 1013 has been cancelled successfully.");

        CancelOrderTool tool = new CancelOrderTool(orderService);

        AgentResult result = tool.execute(1013L);

        assertTrue(result.isSuccess());
        assertFalse(result.isRequiresHuman());
        verify(orderService).cancelOrder("1013");
    }

    @Test
    void rejectedCancellationShouldRequireHumanReview() {

        OrderService orderService = mock(OrderService.class);

        when(orderService.cancelOrder("1007"))
                .thenReturn(
                        "Order 1007 cannot be cancelled because its current status is SHIPPED."
                );

        CancelOrderTool tool = new CancelOrderTool(orderService);

        AgentResult result = tool.execute(1007L);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
    }

    @Test
    void missingOrderIdShouldRequireHumanReview() {

        OrderService orderService = mock(OrderService.class);

        CancelOrderTool tool = new CancelOrderTool(orderService);

        AgentResult result = tool.execute(null);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
        verifyNoInteractions(orderService);
    }
}
