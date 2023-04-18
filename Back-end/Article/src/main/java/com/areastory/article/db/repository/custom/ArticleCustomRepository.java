package com.areastory.article.db.repository.custom;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.request.ArticleReq;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ArticleCustomRepository {
    Page<ArticleDto> findAll(ArticleReq articleReq, Pageable pageable);

    ArticleDto findById(Long userId, Long articleId);
}
