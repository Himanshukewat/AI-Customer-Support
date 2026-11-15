package com.aicustomersupport.springboot.service;

import com.aicustomersupport.springboot.dto.SupportUserResponse;
import com.aicustomersupport.springboot.entity.SupportUser;
import com.aicustomersupport.springboot.repository.SupportUserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;

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

    // Get All Agents
    public List<SupportUserResponse> getAllAgents() {
        return userRepository.findAll()
                .stream()
                .filter(user -> "AGENT".equals(user.getRole()))
                .map(SupportUserResponse::new)
                .toList();
    }

    // Get Agent By ID
    public SupportUserResponse getAgentById(Long id) {
        SupportUser user = getAgent(id);
        return new SupportUserResponse(user);
    }

    // Update Agent
    public SupportUserResponse updateAgent(
            Long id, String name, String email) {
        SupportUser user = getAgent(id);
        if (name != null && !name.isBlank()) {
            user.setName(name);
        }
        if (email != null && !email.isBlank()) {
            userRepository.findByEmail(email)
                    .filter(existing -> !existing.getId().equals(id))
                    .ifPresent(existing -> {
                        throw new IllegalArgumentException(
                                "Email already exists");
                    });
            user.setEmail(email);
        }
        return new SupportUserResponse(userRepository.save(user));
    }

    // Activate / Deactivate Agent
    public SupportUserResponse updateAgentStatus(
            Long id, boolean active) {
        SupportUser user = getAgent(id);
        user.setActive(active);
        return new SupportUserResponse(userRepository.save(user));
    }

    // Find Agent
    private SupportUser getAgent(Long id) {
        SupportUser user = userRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "User not found"));
        if (!"AGENT".equals(user.getRole())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "User is not an agent");
        }
        return user;
    }
}
