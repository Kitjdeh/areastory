package com.areastory.user.dto.response;

import com.areastory.user.db.entity.Article;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ArticleResp {

    private String content;
    private String image;
    private Long like_count;
    private Long comment_count;

    public static ArticleResp fromEntity(Article article) {
        return ArticleResp.builder()
                .content(article.getContent())
                .image(article.getImage())
                .like_count(article.getTotalLikeCount())
                .comment_count(article.getCommentCount())
                .build();
    }
}
