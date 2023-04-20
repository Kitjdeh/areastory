package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
public class ArticleTest {
    private Long articleId;
    private String nickname;
    private String profile;
    private String content;
    private String image;
    private Long likeCount;
    private Boolean isLike;
    private List<CommentTest> comments = new ArrayList<>();

    public ArticleTest(Long articleId, String nickname, String profile, String content, String image, Long likeCount, Boolean isLike, List<CommentTest> comments) {
        this.articleId = articleId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.image = image;
        this.likeCount = likeCount;
        this.isLike = isLike;
        this.comments = comments;
    }
}
