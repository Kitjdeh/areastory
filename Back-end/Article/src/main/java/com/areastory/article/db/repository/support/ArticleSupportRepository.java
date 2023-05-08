package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.ArticleReq;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ArticleSupportRepository {
    Page<ArticleDto> findAll(ArticleReq articleReq, Pageable pageable);

    ArticleDto findById(Long userId, Long articleId);

    Page<UserDto> findAllLike(Long userId, Long articleId, Pageable pageable);

    Page<ArticleDto> findMyLikeList(Long userId, Pageable pageable);


    Page<ArticleDto> findAllFollowArticleList(Long userId, Pageable pageable);
}
