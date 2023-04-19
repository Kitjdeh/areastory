package com.areastory.article.api.service;

public interface ArticleLikeService {
    void addLike(Long userId, Long articleId);

    void deleteLike(Long userId, Long articleId);
}
