package com.aicustomersupport.springboot.service;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;


class TeamRoutingServiceTest {

    private final TeamRoutingService teamRoutingService = new TeamRoutingService();

    @Test
    void shouldPaymentTOBillingTeam(){
        assertEquals("PAYMENTS_BILLING", teamRoutingService.getTeam("PAYMENT"));
    }

    @Test
    void shouldRouteRefundToRefundsTeam() {
        assertEquals("REFUNDS_RETURNS",teamRoutingService.getTeam("REFUND"));
    }

    @Test
    void shouldRouteOrderToOrderManagementTeam() {
        assertEquals( "ORDER_MANAGEMENT",teamRoutingService.getTeam("ORDER"));
    }

    @Test
    void shouldRouteDeliveryToDeliveryTeam() {
        assertEquals( "DELIVERY_SUPPORT",teamRoutingService.getTeam("DELIVERY"));
    }

    @Test
    void shouldRouteAccountToTechnicalSupportTeam() {
        assertEquals("ACCOUNT_TECHNICAL_SUPPORT",teamRoutingService.getTeam("ACCOUNT"));
    }

    @Test
    void shouldRouteFeedbackToCustomerExperienceTeam() {
        assertEquals("CUSTOMER_EXPERIENCE",teamRoutingService.getTeam("FEEDBACK"));
    }

    @Test
    void shouldRouteUnknownCategoryToGeneralSupport() {
        assertEquals("GENERAL_SUPPORT",teamRoutingService.getTeam("UNKNOWN"));
    }

    @Test
    void shouldHandleNullCategory() {
        assertEquals("GENERAL_SUPPORT",teamRoutingService.getTeam(null));
    }
}
