package com.aicustomersupport.springboot;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder =
                new BCryptPasswordEncoder();
        String hash = encoder.encode("Agent@12345");
        System.out.println("Password Hash: " + hash);
    }
}