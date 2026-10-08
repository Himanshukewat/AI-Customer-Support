package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.entity.Order;

@Service 
public class AgentService {
    private final OrderService orderService;

    public AgentService(OrderService orderService) {
        this.orderService = orderService;
    }

    public AgentResult handleTicket(String subCategory, Long orderId){
        System.out.println("AGENT SUBCATEGORY = [" + subCategory + "]");
        System.out.println("AGENT ORDER ID = [" + orderId + "]");
        if("track_order".equalsIgnoreCase(subCategory)){
            if(orderId == null){
                return new AgentResult(
                    false,
                    true,
                    "Order ID is required to track the order."
                );
            }
            Order order = orderService.getOrderByOrderId(String.valueOf(orderId));
            if(order == null){
                return new AgentResult(
                    false,
                    true,
                    "Order not found."
                );
            }
            return new AgentResult(
                true,
                false,
                "Order " + order.getOrderId() + " is currently " + order.getStatus() + "."
            );
        }
        
        if ("cancel_order".equalsIgnoreCase(subCategory)) {
            if (orderId == null) {
                return new AgentResult(
                    false,
                    true,
                    "Order ID is required to cancel the order."
                );
            }
            String result = orderService.cancelOrder(String.valueOf(orderId));
            return new AgentResult(
                true,
                false,
                result
            );
        }
        return new AgentResult(
            false,
            true,
            "This request requires human review."
        );
    }

}
