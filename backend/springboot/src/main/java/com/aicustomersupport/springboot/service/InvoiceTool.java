package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Invoice;
import org.springframework.stereotype.Component;

@Component
public class InvoiceTool implements AgentTool {
    private final InvoiceService invoiceService;

    public InvoiceTool(InvoiceService invoiceService) {
        this.invoiceService = invoiceService;
    }

    @Override
    public String getName() {
        return "check_invoice";
    }

    @Override
    public AgentResult execute(Long orderId) {
        if (orderId == null) {
            return new AgentResult(
                    false,
                    true,
                    "Order ID is required to check the invoice."
            );
        }
        Invoice invoice = invoiceService.getInvoiceByOrderId(String.valueOf(orderId));
        if (invoice == null) {
            return new AgentResult(
                    false,
                    true,
                    "No invoice found for order " + orderId + "."
            );
        }

        return new AgentResult(
                true,
                false,
                "Invoice " + invoice.getInvoiceId()
                        + " for order " + orderId
                        + " is currently " + invoice.getStatus()
                        + " for amount " + invoice.getAmount() + "."
        );
    }
    
}
