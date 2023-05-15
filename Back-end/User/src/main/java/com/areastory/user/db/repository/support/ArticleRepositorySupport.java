package com.areastory.user.db.repository.support;


import com.areastory.user.dto.common.ArticleDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ArticleRepositorySupport {
    Page<ArticleDto> getOtherUserArticleList(Long userId, Pageable pageable);

//    Page<ArticleDto> getOtherUserArticleList(Long userId, Pageable pageable);

//    List<ArticleResp> getArticleList(Long userId);

//    List<ArticleResp> getOtherUserArticleList(Long userId);
}
