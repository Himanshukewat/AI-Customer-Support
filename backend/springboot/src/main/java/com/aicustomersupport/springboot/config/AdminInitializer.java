package com.aicustomersupport.springboot.config;

import com.aicustomersupport.springboot.entity.SupportUser;
import com.aicustomersupport.springboot.repository.SupportUserRepository;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

// this for intial admin creation in database when application starts for the first time
@Configuration
public class AdminInitializer {

    @Value("${app.admin.name}")
    private String adminName;

    @Value("${app.admin.email}")
    private String adminEmail;

    @Value("${app.admin.password}")
    private String adminPassword;

    @Bean
    public CommandLineRunner createInitialAdmin(
            SupportUserRepository userRepository,
            PasswordEncoder passwordEncoder) {

        return args -> {

            if (userRepository.existsByRole("ADMIN")) {
                System.out.println("Admin account already exists.");
                return;
            }

            SupportUser admin = new SupportUser();

            admin.setName(adminName);
            admin.setEmail(adminEmail);
            admin.setPassword(passwordEncoder.encode(adminPassword));
            admin.setRole("ADMIN");
            admin.setActive(true);

            userRepository.save(admin);

            System.out.println("Initial Admin account created successfully.");
        };
    }
}
