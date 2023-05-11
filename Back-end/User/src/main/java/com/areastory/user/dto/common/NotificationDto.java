package com.areastory.user.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class NotificationDto {
    private Long notificationId;
    private Boolean checked;
    private String title;
    private String body;
    private LocalDateTime createdAt;
    private Long articleId;
    private Long commentId;
    private Long userId;
    private String type; 
}
