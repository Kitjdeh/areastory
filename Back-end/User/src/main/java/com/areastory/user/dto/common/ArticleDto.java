package com.areastory.user.dto.common;

import com.areastory.user.db.entity.Article;
import com.areastory.user.dto.response.ArticleResp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ArticleDto {

    private String content;
    private String image;
    private Long like_count;
    private Long comment_count;

    public static ArticleDto fromEntity(Article article) {
        return ArticleDto.builder()
                .content(article.getContent())
                .image(article.getImage())
                .like_count(article.getTotalLikeCount())
                .comment_count(article.getCommentCount())
                .build();
    }

}
