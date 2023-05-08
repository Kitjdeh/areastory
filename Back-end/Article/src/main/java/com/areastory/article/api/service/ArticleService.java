package com.areastory.article.api.service;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import com.areastory.article.dto.response.ArticleResp;
import com.areastory.article.dto.response.LikeResp;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

public interface ArticleService {

    void addArticle(ArticleWriteReq articleWriteReq, MultipartFile picture);

    ArticleResp selectAllArticle(ArticleReq articleReq, Pageable pageable);

    ArticleDto selectArticle(Long userId, Long articleId);

    void updateArticle(ArticleUpdateParam param);

    void deleteArticle(Long userId, Long articleId);

    void addArticleLike(Long userId, Long articleId);

    void deleteArticleLike(Long userId, Long articleId);

    LikeResp selectAllLikeList(Long userId, Long articleId, Pageable pageable);

    ArticleResp selectMyLikeList(Long userId, Pageable pageable);

    ArticleResp selectAllFollowArticle(Long userId, Pageable pageable);
}
