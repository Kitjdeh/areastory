package com.areastory.user.dto.response;

import com.areastory.user.db.entity.Article;
import com.areastory.user.dto.common.ArticleDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;


@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ArticleResp {

    private Long articleId;
    private String image;

    public static ArticleResp fromEntity(Article article) {
        return ArticleResp.builder()
                .articleId(article.getArticleId())
                .image(article.getImage())
                .build();
    }
}
