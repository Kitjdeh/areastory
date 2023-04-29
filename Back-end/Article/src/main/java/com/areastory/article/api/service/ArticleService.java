package com.areastory.article.api.service;

import com.areastory.article.dto.common.ArticleRespDto;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import com.areastory.article.dto.response.ArticleResp;
import com.areastory.article.dto.response.LikeResp;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface ArticleService {

    void addArticle(ArticleWriteReq articleWriteReq, MultipartFile picture) throws IOException;

    ArticleResp selectAllArticle(ArticleReq articleReq, Pageable pageable);

    ArticleRespDto selectArticle(Long userId, Long articleId);

    boolean updateArticle(ArticleUpdateParam param);

    boolean deleteArticle(Long userId, Long articleId);

    boolean addArticleLike(Long userId, Long articleId);

    boolean deleteArticleLike(Long userId, Long articleId);

    LikeResp selectAllLikeList(Long userId, Long articleId, Pageable pageable);
}
