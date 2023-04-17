package com.areastory.article.api.controller;

import com.areastory.article.api.service.ArticleService;
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
     */
    @ApiOperation(value = "모든 게시물 불러오기", notes = "모든 게시물 부르기")
    @GetMapping("/articles")
    public ResponseEntity<?> selectAllArticle(@PageableDefault(size = 15, sort = "likeCount", direction = Sort.Direction.DESC) Pageable pageable) {
        return new ResponseEntity<>(articleService.selectAllArticle(pageable), HttpStatus.OK);
    }

    /*
    특정 게시물 불러오기
     */
    @ApiOperation(value = "게시물 상세 불러오기", notes = "특정 게시물 상세 불러오기")
    @GetMapping("/article/{articleId}")
    public ResponseEntity<?> selectArticle(@PathVariable Long articleId) {
        return new ResponseEntity<>(articleService.selectArticle(articleId), HttpStatus.OK);
    }

    /*
    게시물 수정
     */
    @ApiOperation(value = "게시물 수정", notes = "게시글 수정")
    @PutMapping("/article")
    public ResponseEntity<?> updateArticle(Long userId,
                                           @RequestPart(required = false) ArticleUpdateParam param,
                                           @RequestPart(value = "picture", required = false) MultipartFile picture) throws IOException {


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
    @DeleteMapping("/article/{articleId}")
    public ResponseEntity<?> deleteArticle(Long userId, @PathVariable Long articleId) {

        boolean check = articleService.deleteArticle(userId, articleId);

        if (!check) {
            return new ResponseEntity<>(FAIL, HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

}
