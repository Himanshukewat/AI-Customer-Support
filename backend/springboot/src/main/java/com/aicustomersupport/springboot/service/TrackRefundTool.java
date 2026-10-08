package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Refund;
import org.springframework.stereotype.Component;

@Component
public class TrackRefundTool implements AgentTool {

    private final RefundService refundService;

    public TrackRefundTool(RefundService refundService) {
        this.refundService = refundService;
    }

    @Override
    public String getName() {
        return "track_refund";
    }

    @Override
    public AgentResult execute(Long orderId) {

        if (orderId == null) {
            return new AgentResult(
                    false,
                    true,
                    "Order ID is required to check the refund."
            );
        }

        Refund refund = refundService.getRefundByOrderId(
                String.valueOf(orderId)
        );

        if (refund == null) {
            return new AgentResult(
                    false,
                    true,
                    "No refund found for order " + orderId + "."
            );
        }

        return new AgentResult(
                true,
                false,
                "Refund for order " + orderId
                        + " is currently " + refund.getStatus()
                        + " for amount " + refund.getAmount() + "."
        );
    }
}