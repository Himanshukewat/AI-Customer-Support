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
        System.out.println("AGENT SUBCATEGORY = [" + subCategory + "]");
        System.out.println("AGENT ORDER ID = [" + orderId + "]");
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
        if ("cancel_order".equalsIgnoreCase(subCategory)) {
            if (orderId == null) {
                return "Order ID is required to cancel the order.";
            }
            return orderService.cancelOrder(String.valueOf(orderId));
        }
        return "This request requires human review.";
    }

}
