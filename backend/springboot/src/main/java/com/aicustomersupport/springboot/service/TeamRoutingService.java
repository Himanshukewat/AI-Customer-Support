package com.aicustomersupport.springboot.service;

import java.util.Locale;

import org.springframework.stereotype.Service;

@Service 
public class TeamRoutingService {

    public String getTeam(String category){
        if(category == null){
            return "GENERAL_SUPPORT";
        }
        switch(category.trim().toUpperCase(Locale.ROOT)){
            case "PAYMENT":
            case "INVOICE":
                return "PAYMENTS_BILLING";

            case "REFUND":
                return "REFUNDS_RETURNS";

            case "ORDER":
            case "CANCEL":
                return "ORDER_MANAGEMENT";

            case "DELIVERY":
            case "SHIPPING":
                return "DELIVERY_SUPPORT";

            case "ACCOUNT":
            case "SUBSCRIPTION":
                return "ACCOUNT_TECHNICAL_SUPPORT";

            case "FEEDBACK":
                return "CUSTOMER_EXPERIENCE";

            case "CONTACT":
            default:
                return "GENERAL_SUPPORT";
        }
    }
    
}
