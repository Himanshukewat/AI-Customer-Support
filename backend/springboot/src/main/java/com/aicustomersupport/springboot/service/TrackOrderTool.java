package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Order;
import org.springframework.stereotype.Component;

@Component
public class TrackOrderTool implements AgentTool {
    private final OrderService orderService;
    
    public TrackOrderTool(OrderService orderService) {
        this.orderService = orderService;
    }

    @Override
    public String getName() {
        return "track_order";
    }

    @Override
    public AgentResult execute(Long orderId) {

        if (orderId == null) {
            return new AgentResult(
                    false,
                    true,
                    "Order ID is required to track the order."
            );
        }

        Order order = orderService.getOrderByOrderId(
                String.valueOf(orderId)
        );

        if (order == null) {
            return new AgentResult(
                    false,
                    true,
                    "Order not found."
            );
        }

        return new AgentResult(
                true,
                false,
                "Order " + order.getOrderId()
                        + " is currently " + order.getStatus() + "."
        );
    }
}