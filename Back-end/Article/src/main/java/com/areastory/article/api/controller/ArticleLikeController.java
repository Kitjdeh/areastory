package com.areastory.article.api.controller;

import com.areastory.article.api.service.ArticleLikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ArticleLikeController {
    private static final String SUCCESS = "SUCCESS";
    private final ArticleLikeService articleLikeService;

    @PostMapping("/likes/articles/{articleId}")
    public ResponseEntity<?> addLike(@PathVariable Long articleId, Long userId) {
        articleLikeService.addLike(userId, articleId);
        return ResponseEntity.ok(SUCCESS);
    }

    @DeleteMapping("/likes/articles/{articleId}")
    public ResponseEntity<?> deleteLike(@PathVariable Long articleId, Long userId) {
        articleLikeService.deleteLike(userId, articleId);
        return ResponseEntity.ok(SUCCESS);
    }
}
