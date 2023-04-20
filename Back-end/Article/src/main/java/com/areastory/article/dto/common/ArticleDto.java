package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
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
//    private Boolean isLike;

    private List<CommentDto> comment = new ArrayList<>();

    public ArticleDto(Long articleId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, List<CommentDto> comment) {
        this.articleId = articleId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.image = image;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
//        this.isLike = isLike;
        this.comment = comment;
    }
}
