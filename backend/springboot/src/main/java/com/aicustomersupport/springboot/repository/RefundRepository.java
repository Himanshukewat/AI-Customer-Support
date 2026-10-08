package com.aicustomersupport.springboot.repository;

import com.aicustomersupport.springboot.entity.Refund;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RefundRepository extends JpaRepository<Refund, Long> {
    Optional<Refund> findByOrderId(String orderId);
}