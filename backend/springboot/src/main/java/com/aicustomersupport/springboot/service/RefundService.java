package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.repository.RefundRepository;
import org.springframework.stereotype.Service;
import com.aicustomersupport.springboot.entity.Refund;


@Service
public class RefundService {

    private final RefundRepository refundRepository;

    public RefundService(RefundRepository refundRepository){
        this.refundRepository = refundRepository;
    }

    public Refund getRefundByOrderId(String orderId) {
        return refundRepository.findByOrderId(orderId).orElse(null);
    }

}
