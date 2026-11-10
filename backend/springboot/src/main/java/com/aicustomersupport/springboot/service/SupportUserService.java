package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.entity.SupportUser;
import com.aicustomersupport.springboot.repository.SupportUserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
public class SupportUserService {
    private final SupportUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    public SupportUserService(
            SupportUserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public SupportUser createUser(
            String name,
            String email,
            String password,
            String role) {

        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already exists");
        }

        if (!role.equals("ADMIN") && !role.equals("AGENT")) {
            throw new IllegalArgumentException("Invalid role");
        }

        SupportUser user = new SupportUser();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);
        user.setActive(true);

        return userRepository.save(user);
    }
}
