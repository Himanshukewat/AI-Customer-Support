package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.entity.Order;

@Service 
public class AgentService {
    private final OrderService orderService;

    public AgentService(OrderService orderService) {
        this.orderService = orderService;
    }

    public String handleTicket(String subCategory, Long orderId){
        if("track_order".equalsIgnoreCase(subCategory)){
            if(orderId == null){
                return "Order ID is required to track the order.";
            }
            Order order = orderService.getOrderByOrderId(String.valueOf(orderId));
            if(order == null){
                return "Order not found.";
            }
            return "Order " + order.getOrderId() + " is currently " + order.getStatus() + ".";
        }
        return "This request requires human review.";
    }

}
