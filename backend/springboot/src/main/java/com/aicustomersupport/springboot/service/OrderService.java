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

}