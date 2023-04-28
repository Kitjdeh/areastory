package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.db.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    Page<Notification> findAllByUser(User user, Pageable pageable);
}
