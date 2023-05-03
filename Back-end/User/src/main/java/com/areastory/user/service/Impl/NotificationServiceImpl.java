package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.NotificationRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.common.NotificationKafkaDto;
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
    public void addNotification(NotificationKafkaDto notificationKafkaDto) {
        User user = userRepository.findById(notificationKafkaDto.getUserId()).orElseThrow();
        User otherUser = userRepository.findById(notificationKafkaDto.getOtherUserId()).orElseThrow();
        Notification notification = notificationRepository.save(toEntity(notificationKafkaDto, user, otherUser));
    }

    @Override
    @Transactional
    public boolean deleteNotification(Long userId, Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElseThrow();
        if (!Objects.equals(notification.getUser().getUserId(), userId))
            return false;
        notificationRepository.delete(notification);
        return true;
    }

    @Override
    public NotificationResp selectAllNotifications(Long userId, Pageable pageable) {
        User user = userRepository.findById(userId).orElseThrow();
        Page<Notification> notifications = notificationRepository.findAllByUser(user, pageable);
        return NotificationResp.builder()
                .notifications(notifications.getContent().stream().map(this::toDto).collect(Collectors.toList()))
                .pageSize(notifications.getPageable().getPageSize())
                .totalPageNumber(notifications.getTotalPages())
                .totalCount(notifications.getTotalElements())
                .build();
    }

    @Override
    @Transactional
    public void checkNotification(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElseThrow();
        notification.check();
    }
}
