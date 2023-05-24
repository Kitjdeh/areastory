package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.db.repository.NotificationRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.common.NotificationDto;
import com.areastory.user.dto.response.NotificationResp;
import com.areastory.user.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public void addNotification(NotificationDto notificationDto) {
        notificationRepository.save(toEntity(notificationDto));
    }

    @Override
    @Transactional
    public boolean deleteNotification(Long userId, Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElseThrow();
        if (!Objects.equals(notification.getUserId(), userId))
            return false;
        notificationRepository.delete(notification);
        return true;
    }

    @Override
    public NotificationResp selectAllNotifications(Long userId, Pageable pageable) {
        Page<Notification> notifications = notificationRepository.findAllByUserId(userId, pageable);
        return NotificationResp.builder()
                .notifications(notifications.getContent().stream().map(this::toDto).collect(Collectors.toList()))
                .pageSize(notifications.getPageable().getPageSize())
                .totalPageNumber(notifications.getTotalPages())
                .totalCount(notifications.getTotalElements())
                .pageNumber(notifications.getPageable().getPageNumber() + 1)
                .nextPage(notifications.hasNext())
                .previousPage(notifications.hasPrevious())
                .build();
    }

    @Override
    public NotificationDto selectNotification(Long userId, Long notificationId) {
        return toDto(notificationRepository.findByNotificationIdAndUserId(notificationId, userId));
    }

    @Override
    @Transactional
    public void checkNotification(Long userId, Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElseThrow();
        if (!Objects.equals(notification.getUserId(), userId))
            return;
        notification.check();
    }

    @Override
    @Transactional
    public void checkAllNotification(Long userId) {
        notificationRepository.checkAll(userId);
    }
}
