package com.areastory.article.db.repository.custom;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.ArticleTest;
import com.areastory.article.dto.request.ArticleReq;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ArticleCustomRepository {
    List<ArticleTest> findAll(ArticleReq articleReq, Pageable pageable);

    ArticleDto findById(Long userId, Long articleId);
}
