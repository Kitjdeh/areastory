package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ArticleLikeService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.ArticleLike;
import com.areastory.article.db.entity.ArticleLikePK;
import com.areastory.article.db.repository.ArticleLikeRepository;
import com.areastory.article.db.repository.ArticleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class ArticleLikeServiceImpl implements ArticleLikeService {
    private final ArticleLikeRepository articleLikeRepository;
    private final ArticleRepository articleRepository;

    public void addLike(Long userId, Long articleId) {
        if (articleLikeRepository.existsById(new ArticleLikePK(articleId, userId)))
            return;
        articleLikeRepository.save(new ArticleLike(userId, articleId));
        Article article = articleRepository.findById(articleId).orElseThrow();
        article.addLikeCount();
    }

    public void deleteLike(Long userId, Long articleId) {
        if (!articleLikeRepository.existsById(new ArticleLikePK(articleId, userId)))
            return;
        articleLikeRepository.delete(new ArticleLike(userId, articleId));
        Article article = articleRepository.findById(articleId).orElseThrow();
        article.removeLikeCount();
    }
}