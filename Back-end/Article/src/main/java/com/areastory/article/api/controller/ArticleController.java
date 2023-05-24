package com.areastory.article.api.controller;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/articles")
public class ArticleController {
    private final ArticleService articleService;

    /*
    게시물 작성
     */
    @PostMapping
    public ResponseEntity<?> writeArticle(@RequestPart(value = "picture", required = false) MultipartFile picture,
                                          @RequestPart ArticleWriteReq articleWriteReq) throws IOException {
        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        System.out.println(picture.getName());
        System.out.println(picture.getContentType());
        System.out.println(picture.getOriginalFilename());
        System.out.println(picture.getInputStream());
        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        articleService.addArticle(articleWriteReq, picture);

        return ResponseEntity.ok().build();
    }

    /*
    모든 게시물 불러오기
    한페이지당 개수는 15개, 정렬은 좋아요 순으로
     */
    @GetMapping
    public ResponseEntity<?> selectAllArticle(ArticleReq articleReq,
                                              @PageableDefault(sort = {"likeCount"}, direction = Sort.Direction.DESC, size = 15) Pageable pageable) {
        return ResponseEntity.ok(articleService.selectAllArticle(articleReq, pageable));
    }


    /*
    팔로우 한 사람들의 sns
     */
    @GetMapping("/follow")
    public ResponseEntity<?> selectAllFollowArticle(Long userId,
                                                    @PageableDefault(sort = {"articleId"}, direction = Sort.Direction.DESC, size = 15) Pageable pageable) {
        return ResponseEntity.ok(articleService.selectAllFollowArticle(userId, pageable));
    }

    /*
    특정 게시물 불러오기
     */
    @GetMapping("/{articleId}")
    public ResponseEntity<?> selectArticle(Long userId, @PathVariable Long articleId) {
        return ResponseEntity.ok(articleService.selectArticle(userId, articleId));
    }

    /*
    게시물 수정
     */
    @PatchMapping("/{articleId}")
    public ResponseEntity<?> updateArticle(@PathVariable Long articleId,
                                           @RequestPart(required = false) ArticleUpdateParam param) {
        param.setArticleId(articleId);
        articleService.updateArticle(param);
        return ResponseEntity.ok().build();
    }

    /*
    게시글 삭제
     */
    @DeleteMapping("/{articleId}")
    public ResponseEntity<?> deleteArticle(Long userId, @PathVariable Long articleId) {
        articleService.deleteArticle(userId, articleId);
        return ResponseEntity.ok().build();
    }

    /*
    게시글 좋아요 누르기
     */
    @PostMapping("/like/{articleId}")
    public ResponseEntity<?> addLike(@PathVariable Long articleId, Long userId) {
        articleService.addArticleLike(userId, articleId);
        return ResponseEntity.ok().build();
    }

    /*
    게시글 좋아요 취소
     */
    @DeleteMapping("/like/{articleId}")
    public ResponseEntity<?> deleteLike(@PathVariable Long articleId, Long userId) {
        articleService.deleteArticleLike(userId, articleId);
        return ResponseEntity.ok().build();
    }

    /*
    해당 게시글에 좋아요 누른 사람들 목록 보기
     */
    @GetMapping("/like/{articleId}")
    public ResponseEntity<?> getLikeList(@PathVariable Long articleId, Long userId,
                                         @PageableDefault(size = 15) Pageable pageable) {
        return ResponseEntity.ok(articleService.selectAllLikeList(userId, articleId, pageable));
    }

    /*
    내가 좋아요 눌렀던 게시글 목록 보기
     */
    @GetMapping("/myLike/{userId}")
    public ResponseEntity<?> getMyLikeList(@PathVariable Long userId,
                                           @PageableDefault(sort = "articleId", direction = Sort.Direction.DESC, size = 15) Pageable pageable) {
        return ResponseEntity.ok(articleService.selectMyLikeList(userId, pageable));
    }
}
