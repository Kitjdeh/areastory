package com.areastory.user.db.repository;

import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.support.UserRepositorySupport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long>, UserRepositorySupport {
    Optional<User> findByProviderId(Long providerId);

    Optional<User> findById(Long userId);

}
