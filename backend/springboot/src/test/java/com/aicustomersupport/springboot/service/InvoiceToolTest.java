package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.Invoice;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class InvoiceToolTest {

    private InvoiceService invoiceService;
    private InvoiceTool invoiceTool;

    @BeforeEach
    void setUp() {
        invoiceService = mock(InvoiceService.class);
        invoiceTool = new InvoiceTool(invoiceService);
    }

    @Test
    void shouldReturnInvoiceDetailsWhenInvoiceExists() {
        Invoice invoice = new Invoice();
        invoice.setStatus("PAID");
        invoice.setAmount(599.0);

        when(invoiceService.getInvoiceByOrderId("1013"))
                .thenReturn(invoice);

        AgentResult result = invoiceTool.execute(1013L);

        assertTrue(result.isSuccess());
        assertFalse(result.isRequiresHuman());
        assertTrue(result.getMessage().contains("PAID"));
    }

    @Test
    void shouldRequireHumanWhenOrderIdIsMissing() {
        AgentResult result = invoiceTool.execute(null);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
        verifyNoInteractions(invoiceService);
    }

    @Test
    void shouldRequireHumanWhenInvoiceDoesNotExist() {
        when(invoiceService.getInvoiceByOrderId("9999"))
                .thenReturn(null);

        AgentResult result = invoiceTool.execute(9999L);

        assertFalse(result.isSuccess());
        assertTrue(result.isRequiresHuman());
    }

    @Test
    void shouldUseCorrectToolName() {
        assertEquals("check_invoice", invoiceTool.getName());
    }
}
