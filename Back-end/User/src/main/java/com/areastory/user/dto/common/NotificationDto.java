package com.areastory.user.dto.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class NotificationDto {
    private Long notificationId;
    private String type;
    private Long articleId;
    private Long commentId;
    private String nickname;
    private String profile;
    private String image;
    private Boolean checked;
}
