package com.aicustomersupport.springboot.repository;

import com.aicustomersupport.springboot.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface OrderRepository extends JpaRepository<Order, Long> {

    Optional<Order> findByOrderId(String orderId);

}
