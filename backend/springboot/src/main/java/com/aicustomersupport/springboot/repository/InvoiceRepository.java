package com.aicustomersupport.springboot.repository;

import com.aicustomersupport.springboot.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    Optional<Invoice> findByOrderId(String orderId);
    
}
