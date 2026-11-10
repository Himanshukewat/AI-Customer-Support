package com.aicustomersupport.springboot.repository;

import com.aicustomersupport.springboot.entity.SupportUser;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface SupportUserRepository extends JpaRepository<SupportUser, Long> {
    Optional<SupportUser> findByEmail(String email);
    boolean existsByEmail(String email);
    boolean existsByRole(String role);
}
