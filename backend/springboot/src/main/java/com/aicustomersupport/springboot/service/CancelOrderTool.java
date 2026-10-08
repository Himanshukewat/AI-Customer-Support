package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Component;

@Component
public class CancelOrderTool implements AgentTool {

    private final OrderService orderService;

    public CancelOrderTool(OrderService orderService) {
        this.orderService = orderService;
    }

    @Override
    public String getName() {
        return "cancel_order";
    }

    @Override
    public AgentResult execute(Long orderId) {

        if (orderId == null) {
            return new AgentResult(
                    false,
                    true,
                    "Order ID is required to cancel the order."
            );
        }

        String result = orderService.cancelOrder(
                String.valueOf(orderId)
        );

        if (result.contains("successfully")) {
            return new AgentResult(
                    true,
                    false,
                    result
            );
        }

        return new AgentResult(
                false,
                true,
                result
        );
    }
}