package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
public class CommentDto {
    private Long commentId;
    private Long articleId;
    private Long userId;
    private String nickname;
    private String profile;
    private String content;
    private Long likeCount;
    private LocalDateTime createdAt;
    private Boolean likeYn;

    public CommentDto(Long commentId, Long articleId, Long userId, String nickname, String profile, String content, Long likeCount, LocalDateTime createdAt, Boolean likeYn) {
        this.commentId = commentId;
        this.articleId = articleId;
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.likeCount = likeCount;
        this.createdAt = createdAt;
        this.likeYn = likeYn;
    }
}
