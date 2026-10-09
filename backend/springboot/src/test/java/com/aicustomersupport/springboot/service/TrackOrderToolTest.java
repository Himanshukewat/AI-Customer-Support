package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Order;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class TrackOrderToolTest {

    private OrderService orderService;
    private TrackOrderTool trackOrderTool;

    @BeforeEach
    // beforeEach is a JUnit 5 annotation that indicates the annotated method should be executed before each test method in the current test class. It is used to set up any necessary preconditions or configurations that are required for the tests to run correctly.
    void setUp() {
        orderService = mock(OrderService.class);
        trackOrderTool = new TrackOrderTool(orderService);
    }

    @Test
    void shouldReturnOrderStatusWhenOrderExists() {
        Order order = new Order();
        order.setOrderId("1007");
        order.setStatus("SHIPPED");

        when(orderService.getOrderByOrderId("1007"))
                .thenReturn(order);

        AgentResult result = trackOrderTool.execute(1007L);

        assertTrue(result.isSuccess());
        assertFalse(result.isRequiresHuman());
        assertTrue(result.getMessage().contains("SHIPPED"));
    }

    @Test
    void shouldRequireHumanWhenOrderIdIsMissing() {
        AgentResult result = trackOrderTool.execute(null);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
        verifyNoInteractions(orderService);
    }

    @Test
    void shouldRequireHumanWhenOrderDoesNotExist() {
        when(orderService.getOrderByOrderId("9999"))
                .thenReturn(null);

        AgentResult result = trackOrderTool.execute(9999L);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
    }

    @Test
    void shouldUseCorrectToolName() {
        assertEquals("track_order", trackOrderTool.getName());
    }
}