package com.areastory.article.dto.common;

import com.querydsl.core.annotations.QueryProjection;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;


@NoArgsConstructor
@Getter
@Setter
public class ArticleDto {
    private Long articleId;
    private String nickname;
    private String profile;
    private String content;
    private String image;
    private Long likeCount;
    private Long commentCount;
    private Boolean isLike;

    private List<CommentDto> comment;

    @QueryProjection
    public ArticleDto(List<CommentDto> comment, Long articleId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, Boolean isLike) {
        this.articleId = articleId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.image = image;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.isLike = isLike;
        this.comment = comment;
    }
}
