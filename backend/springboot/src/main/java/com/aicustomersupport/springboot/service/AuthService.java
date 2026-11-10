package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.dto.AuthResponse;
import com.aicustomersupport.springboot.dto.LoginRequest;
import com.aicustomersupport.springboot.entity.SupportUser;
import com.aicustomersupport.springboot.repository.SupportUserRepository;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final SupportUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(
            SupportUserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService) {

        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public AuthResponse login(LoginRequest request) {

        SupportUser user = userRepository
                .findByEmail(request.getEmail().trim())
                .orElseThrow(() ->
                        new BadCredentialsException("Invalid email or password"));

        if (!user.isActive()) {
            throw new DisabledException("Account is disabled");
        }

        if (!passwordEncoder.matches(
                request.getPassword(), user.getPassword())) {

            throw new BadCredentialsException("Invalid email or password");
        }

        String token = jwtService.generateToken(
                user.getEmail(), user.getRole());

        return new AuthResponse(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getRole(),
                token
        );
    }
}
