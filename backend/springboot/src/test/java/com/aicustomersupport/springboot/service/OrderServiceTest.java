package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Order;
import com.aicustomersupport.springboot.repository.OrderRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class OrderServiceTest {

    private OrderRepository orderRepository;
    private OrderService orderService;

    @BeforeEach
    void setUp() {
        orderRepository = mock(OrderRepository.class);
        orderService = new OrderService(orderRepository);
    }

    @Test
    void pendingOrderShouldBeCancelled() {

        Order order = new Order();
        order.setOrderId("1013");
        order.setStatus("PENDING");

        when(orderRepository.findByOrderId("1013"))
                .thenReturn(Optional.of(order));

    CancelOrderResult result = orderService.cancelOrder("1013");
        assertEquals("CANCELLED", order.getStatus());
        assertTrue(result.isSuccess());
        verify(orderRepository).save(order);
    }

    @Test
    void shippedOrderShouldNotBeCancelled() {

        Order order = new Order();
        order.setOrderId("1007");
        order.setStatus("SHIPPED");
        when(orderRepository.findByOrderId("1007"))
                .thenReturn(Optional.of(order));

        CancelOrderResult result = orderService.cancelOrder("1007");
        assertEquals("SHIPPED", order.getStatus());
        assertFalse(result.isSuccess());
        verify(orderRepository, never()).save(any(Order.class));
    }

    @Test
    void alreadyCancelledOrderShouldRemainCancelled() {

        Order order = new Order();
        order.setOrderId("1013");
        order.setStatus("CANCELLED");
        when(orderRepository.findByOrderId("1013"))
                .thenReturn(Optional.of(order));

        CancelOrderResult result = orderService.cancelOrder("1013");

        assertEquals("CANCELLED", order.getStatus());
        assertFalse(result.isSuccess());
        verify(orderRepository, never()).save(any(Order.class));
    }

    @Test
    void missingOrderShouldReturnFailure() {
        when(orderRepository.findByOrderId("9999"))
                .thenReturn(Optional.empty());

        CancelOrderResult result = orderService.cancelOrder("9999");

        assertFalse(result.isSuccess());
        assertEquals("Order not found.", result.getMessage());
        verify(orderRepository, never()).save(any(Order.class));
    }
}
