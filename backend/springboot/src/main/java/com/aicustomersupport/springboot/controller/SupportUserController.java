package com.aicustomersupport.springboot.controller;

import com.aicustomersupport.springboot.dto.SupportUserResponse;
import com.aicustomersupport.springboot.entity.SupportUser;
import com.aicustomersupport.springboot.service.SupportUserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/users")
@PreAuthorize("hasRole('ADMIN')")
public class SupportUserController {

    private final SupportUserService userService;

    public SupportUserController(SupportUserService userService) {
        this.userService = userService;
    }

    // Create Agent
    @PostMapping
    public ResponseEntity<SupportUserResponse> createAgent(
            @RequestBody CreateUserRequest request) {

        SupportUser user = userService.createUser(
                request.getName(),
                request.getEmail(),
                request.getPassword(),
                "AGENT"
        );

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new SupportUserResponse(user));
    }

    // Get All Agents
    @GetMapping
    public ResponseEntity<List<SupportUserResponse>> getAllAgents() {
        return ResponseEntity.ok(userService.getAllAgents());
    }

    // Get Agent By ID
    @GetMapping("/{id}")
    public ResponseEntity<SupportUserResponse> getAgentById(
            @PathVariable Long id) {

        return ResponseEntity.ok(userService.getAgentById(id));
    }

    // Update Agent
    @PutMapping("/{id}")
    public ResponseEntity<SupportUserResponse> updateAgent(
            @PathVariable Long id,
            @RequestBody UpdateUserRequest request) {

        return ResponseEntity.ok(
                userService.updateAgent(
                        id, request.getName(), request.getEmail()
                )
        );
    }

    // Activate / Deactivate Agent
    @PatchMapping("/{id}/status")
    public ResponseEntity<SupportUserResponse> updateAgentStatus(
            @PathVariable Long id,
            @RequestParam boolean active) {

        return ResponseEntity.ok(
                userService.updateAgentStatus(id, active)
        );
    }

    // Request DTOs
    public static class CreateUserRequest {
        private String name;
        private String email;
        private String password;

        public String getName() { return name; }
        public String getEmail() { return email; }
        public String getPassword() { return password; }

        public void setName(String name) { this.name = name; }
        public void setEmail(String email) { this.email = email; }
        public void setPassword(String password) { this.password = password; }
    }

    public static class UpdateUserRequest {
        private String name;
        private String email;

        public String getName() { return name; }
        public String getEmail() { return email; }

        public void setName(String name) { this.name = name; }
        public void setEmail(String email) { this.email = email; }
    }
}
