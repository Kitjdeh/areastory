package com.areastory.user.response;

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
                .like_count(article.getLike_count())
                .comment_count(article.getComment_count())
                .build();
    }
}
