package com.areastory.user.dto.common;

import com.areastory.user.db.entity.Article;
import com.areastory.user.dto.response.ArticleResp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ArticleDto {

    private Long articleId;
    private String image;

    public static ArticleDto fromEntity(Article article) {
        return ArticleDto.builder()
                .articleId(article.getArticleId())
                .image(article.getImage())
                .build();
    }

}
