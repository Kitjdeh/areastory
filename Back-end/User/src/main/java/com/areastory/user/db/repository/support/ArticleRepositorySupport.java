package com.areastory.user.db.repository.support;

import com.areastory.user.dto.response.ArticleResp;

import java.util.List;

public interface ArticleRepositorySupport {

//    Page<ArticleDto> getOtherUserArticleList(Long userId, Pageable pageable);

    List<ArticleResp> getArticleList(Long userId);

    List<ArticleResp> getOtherUserArticleList(Long userId);
}
