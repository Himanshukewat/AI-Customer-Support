package com.aicustomersupport.springboot.service;

import lombok.Data;

@Data
public class CancelOrderResult {
    private boolean success;
    private String message;

    public CancelOrderResult(boolean success, String message) {
        this.success = success;
        this.message = message;
    }
}
