package com.areastory.article.api.service;

import com.areastory.article.db.entity.Article;
import com.areastory.article.dto.common.ArticleDetailDto;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.response.ArticleResp;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface ArticleService {

    void addArticle(Long userId, String content, MultipartFile picture) throws IOException;

    ArticleResp selectAllArticle(Pageable pageable);

    ArticleDetailDto selectArticle(Long articleId);

    boolean updateArticle(Long userId, ArticleUpdateParam param, MultipartFile picture) throws IOException;

    boolean deleteArticle(Long userId, Long articleId);

    default ArticleDetailDto toDto(Article article) {
        return ArticleDetailDto.builder()
                .nickname(article.getUser().getNickname())
                .content(article.getContent())
                .picture(article.getImage())
                .likeCount(article.getLikeCount())
                .commentCount(article.getCommentCount())
                .build();
    }
}
