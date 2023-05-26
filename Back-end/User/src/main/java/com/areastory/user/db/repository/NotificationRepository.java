package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.db.repository.support.NotificationRepositorySupport;
import com.areastory.user.dto.common.NotificationDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Long>, NotificationRepositorySupport {
    Page<Notification> findAllByUserId(Long userId, Pageable pageable);

    Notification findByNotificationIdAndUserId(Long notificationId, Long userId);
}
