package com.areastory.user.service;

import com.areastory.user.db.entity.Notification;
import com.areastory.user.db.entity.User;
import com.areastory.user.dto.common.NotificationDto;
import com.areastory.user.dto.common.NotificationKafkaDto;
import com.areastory.user.dto.response.NotificationResp;
import org.springframework.data.domain.Pageable;

public interface NotificationService {

    void addNotification(NotificationKafkaDto notificationKafkaDto);

    boolean deleteNotification(Long userId, Long notificationId);

    NotificationResp selectAllNotifications(Long userId, Pageable pageable);

    void checkNotification(Long notificationId);

    default Notification toEntity(NotificationKafkaDto notificationKafkaDto, User user, User otherUser) {
        return Notification.builder()
                .type(notificationKafkaDto.getType())
                .articleId(notificationKafkaDto.getArticleId())
                .commentId(notificationKafkaDto.getCommentId())
                .image(notificationKafkaDto.getImage())
                .user(user)
                .otherUser(otherUser)
                .build();
    }

    default NotificationDto toDto(Notification notification) {
        return NotificationDto.builder()
                .notificationId(notification.getNotificationId())
                .type(notification.getType())
                .articleId(notification.getArticleId())
                .commentId(notification.getCommentId())
                .nickname(notification.getUser().getNickname())
                .profile(notification.getUser().getProfile())
                .image(notification.getImage())
                .checked(notification.getChecked())
                .build();
    }
}
