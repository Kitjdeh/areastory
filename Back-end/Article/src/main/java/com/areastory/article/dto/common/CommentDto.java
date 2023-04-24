package com.areastory.article.dto.common;

import com.querydsl.core.annotations.QueryProjection;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
public class CommentDto {
    private Long commentId;
    private Long articleId;
    private String nickname;
    private String profile;
    private String content;
    private Long likeCount;
    private LocalDateTime createdAt;
    private Boolean isLike;

    @QueryProjection
    public CommentDto(Long commentId, Long articleId, String nickname, String profile, String content, Long likeCount, LocalDateTime createdAt, Boolean isLike) {
        this.commentId = commentId;
        this.articleId = articleId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.likeCount = likeCount;
        this.createdAt = createdAt;
        this.isLike = isLike;
    }
}
