package com.areastory.user.dto.common;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@EqualsAndHashCode
@ToString
@SuperBuilder
public class NotificationKafkaDto implements Serializable {
    private String type;
    private Long articleId;
    private String articleContent;
    private Long commentId;
    private String commentContent;
    private Long userId;
    private String username;
    private Long otherUserId;
    private String otherUsername;
    private String image;
    private LocalDateTime createdAt;
}