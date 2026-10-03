package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.repository.OrderRepository;

import com.aicustomersupport.springboot.entity.Order;

@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    public Order getOrderByOrderId(String orderId) {
        return orderRepository.findByOrderId(orderId).orElse(null);
    }

    public String cancelOrder(String orderId){
        Order order = orderRepository.findByOrderId(orderId).orElse(null);
        if(order == null){
            return "Order not found.";
        }

        String currentStatus = order.getStatus();

        if ("PENDING".equalsIgnoreCase(currentStatus)
                || "PROCESSING".equalsIgnoreCase(currentStatus)) {

            order.setStatus("CANCELLED");
            orderRepository.save(order);

            return "Order " + orderId + " has been cancelled successfully.";
        }

        if( "CANCELLED".equalsIgnoreCase(currentStatus)){
            return "Order " + orderId + " is already cancelled.";
        }

        return "Order " + orderId
            + " cannot be cancelled because its current status is "
            + currentStatus + ".";

    }

}
