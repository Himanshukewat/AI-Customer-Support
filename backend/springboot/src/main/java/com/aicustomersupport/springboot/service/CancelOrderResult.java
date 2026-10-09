package com.aicustomersupport.springboot.service;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CancelOrderResult {
    private boolean success;
    private String message;
}
