package com.areastory.article.dto.common;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@NoArgsConstructor
@Getter
@Setter
public class ArticleRespDto {
    private Long articleId;
    private Long userId;
    private String nickname;
    private String profile;
    private String content;
    private String image;
    private Long likeCount;
    private Long commentCount;
    private String location;
    private Boolean isLike;
    private LocalDateTime createdAt;

    @Builder
    public ArticleRespDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, String location, Boolean isLike, LocalDateTime createdAt) {
        this.articleId = articleId;
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.image = image;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.location = location;
        this.isLike = isLike;
        this.createdAt = createdAt;
    }
}
