package com.areastory.article.api.controller;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Api(tags = {"게시물 관련 API"})
public class ArticleController {

    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    private final ArticleService articleService;

    /*
    게시물 작성
     */
    @ApiOperation(value = "게시물 작성", notes = "게시글 작성")
    @PostMapping("/articles")
    public ResponseEntity<?> writeArticle(Long userId,
                                          @RequestPart(value = "picture", required = false) MultipartFile picture,
                                          @RequestPart(required = false) String content) throws IOException {
        articleService.addArticle(userId, content, picture);
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

    /*
    모든 게시물 불러오기
    한페이지당 개수는 15개, 정렬은 좋아요 순으로
    댓글은 우선 2개만 보여주기
     */
    @ApiOperation(value = "모든 게시물 불러오기", notes = "모든 게시물 부르기")
    @GetMapping("/articles")
    public ResponseEntity<?> selectAllArticle(@RequestBody ArticleReq articleReq,
                                              @PageableDefault(size = 15, sort = "likeCount", direction = Sort.Direction.DESC) Pageable pageable) {
        System.out.println("모든");
        return new ResponseEntity<>(articleService.selectAllArticle(articleReq, pageable), HttpStatus.OK);
    }

    /*
    특정 게시물 불러오기
    댓글 10개 보여주기
     */
    @ApiOperation(value = "게시물 상세 불러오기", notes = "특정 게시물 상세 불러오기")
    @GetMapping("/articles/{articleId}")
    public ResponseEntity<?> selectArticle(Long userId, @PathVariable Long articleId) {
        System.out.println("상세");
        return new ResponseEntity<>(articleService.selectArticle(userId, articleId), HttpStatus.OK);
    }

    /*
    게시물 수정
     */
    @ApiOperation(value = "게시물 수정", notes = "게시글 수정")
    @PutMapping("/articles/{articleId}")
    public ResponseEntity<?> updateArticle(Long userId, @PathVariable Long articleId,
                                           @RequestPart(required = false) ArticleUpdateParam param,
                                           @RequestPart(value = "picture", required = false) MultipartFile picture) throws IOException {

        param.setArticleId(articleId);
        boolean check = articleService.updateArticle(userId, param, picture);
        if (!check) {
            return new ResponseEntity<>(FAIL, HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

    /*
    게시글 삭제
     */
    @ApiOperation(value = "게시물 삭제", notes = "게시글 삭제")
    @DeleteMapping("/articles/{articleId}")
    public ResponseEntity<?> deleteArticle(Long userId, @PathVariable Long articleId) {

        boolean check = articleService.deleteArticle(userId, articleId);

        if (!check) {
            return new ResponseEntity<>(FAIL, HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

}
