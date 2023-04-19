package com.areastory.article.dto.common;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class CommentDto {
    private Long commentId;
    private Long articleId;
    private String nickname;
    private String profile;
    private String content;
    private Long likeCount;
    private Boolean isLike;

    @Builder
    public CommentDto(Long commentId, Long articleId, String nickname, String profile, String content, Long likeCount, Boolean isLike) {
        this.commentId = commentId;
        this.articleId = articleId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.likeCount = likeCount;
        this.isLike = isLike;
    }
}
