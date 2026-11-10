
package com.aicustomersupport.springboot.controller;

import com.aicustomersupport.springboot.dto.AuthResponse;
import com.aicustomersupport.springboot.dto.LoginRequest;
import com.aicustomersupport.springboot.service.AuthService;

import jakarta.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = authService.login(request);
            return ResponseEntity.ok(response);

        } catch (BadCredentialsException e) {
            return ResponseEntity.status(401)
                    .body("Invalid email or password");

        } catch (DisabledException e) {
            return ResponseEntity.status(403)
                    .body("Account is disabled");
        }
    }
}
