package com.areastory.article.api.service;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.ArticleTest;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ArticleService {

    void addArticle(Long userId, ArticleWriteReq articleWriteReq, MultipartFile picture) throws IOException;

    List<ArticleTest> selectAllArticle(ArticleReq articleReq, Pageable pageable);

    ArticleDto selectArticle(Long userId, Long articleId);

    boolean updateArticle(Long userId, ArticleUpdateParam param, MultipartFile picture) throws IOException;

    boolean deleteArticle(Long userId, Long articleId);

//    default ArticleDetailDto toDto(Article article) {
//        return ArticleDetailDto.builder()
//                .nickname(article.getUser().getNickname())
//                .content(article.getContent())
//                .image(article.getImage())
//                .likeCount(article.getLikeCount())
//                .commentCount(article.getCommentCount())
//                .build();
//    }
}
