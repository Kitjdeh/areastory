package com.areastory.user.service;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.dto.common.NotificationDto;
import com.areastory.user.dto.response.NotificationResp;
import org.springframework.data.domain.Pageable;

public interface NotificationService {

    void addNotification(NotificationDto notificationDto);

    boolean deleteNotification(Long userId, Long notificationId);

    NotificationResp selectAllNotifications(Long userId, Pageable pageable);
    NotificationDto selectNotification(Long userId,Long notificationId);

    void checkNotification(Long userId, Long notificationId);

    void checkAllNotification(Long userId);

    default Notification toEntity(NotificationDto notificationDto) {
        return Notification.builder()
                .title(notificationDto.getTitle())
                .body(notificationDto.getBody())
                .createdAt(notificationDto.getCreatedAt())
                .articleId(notificationDto.getArticleId())
                .commentId(notificationDto.getCommentId())
                .userId(notificationDto.getUserId())
                .otherUserId(notificationDto.getOtherUserId())
                .type(notificationDto.getType())
                .build();
    }

    default NotificationDto toDto(Notification notification) {
        return NotificationDto.builder()
                .notificationId(notification.getNotificationId())
                .title(notification.getTitle())
                .body(notification.getBody())
                .checked(notification.getChecked())
                .createdAt(notification.getCreatedAt())
                .articleId(notification.getArticleId())
                .commentId(notification.getCommentId())
                .userId(notification.getUserId())
                .otherUserId(notification.getOtherUserId())
                .type(notification.getType())
                .build();
    }
}
