package com.areastory.article.dto.common;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Data
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

    @Builder
    public NotificationKafkaDto(String type, Long articleId, String articleContent, Long commentId, String commentContent, Long userId, String username, Long otherUserId, String otherUsername, String image) {
        this.type = type;
        this.articleId = articleId;
        this.articleContent = articleContent;
        this.commentId = commentId;
        this.commentContent = commentContent;
        this.userId = userId;
        this.username = username;
        this.otherUserId = otherUserId;
        this.otherUsername = otherUsername;
        this.image = image;
    }
}