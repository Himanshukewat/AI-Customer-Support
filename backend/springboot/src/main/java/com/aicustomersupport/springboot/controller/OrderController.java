package com.aicustomersupport.springboot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import com.aicustomersupport.springboot.service.OrderService;
import com.aicustomersupport.springboot.entity.Order;


@RestController 
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }


    @GetMapping("/orders/{orderId}")
    public Order getOrderByOrderId(@PathVariable String orderId) {
        return orderService.getOrderByOrderId(orderId);
    }
    
}
