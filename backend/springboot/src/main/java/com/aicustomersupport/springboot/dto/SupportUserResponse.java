package com.aicustomersupport.springboot.dto;

import com.aicustomersupport.springboot.entity.SupportUser;

public class SupportUserResponse {
    private Long id;
    private String name;
    private String email;
    private String role;
    private boolean active;
    public SupportUserResponse(SupportUser user) {
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.role = user.getRole();
        this.active = user.isActive();
    }
    public Long getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public String getEmail() {
        return email;
    }
    public String getRole() {
        return role;
    }
    public boolean isActive() {
        return active;
    }
}