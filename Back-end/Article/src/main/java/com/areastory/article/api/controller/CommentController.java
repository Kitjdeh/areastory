package com.areastory.article.api.controller;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.dto.request.CommentReq;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/articles")
@Api(tags = {"댓글 관련 API"})
public class CommentController {
    private static final String SUCCESS = "success";
    private static final String FAIL = "fail";
    private final CommentService commentService;


    /*
    댓글 작성
     */
    @ApiOperation(value = "댓글 작성", notes = "댓글 작성")
    @PostMapping("/comments")
    public ResponseEntity<?> writeComment(@RequestBody CommentReq commentReq) {
        commentService.addComment(commentReq);
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

    /*
    해당 게시글의 댓글 가져오기 => 게시글 자세히 가져올 때 댓글 리스트를 넣는데 모든 댓글을 부르는 게 필요할까?
     */
//    @ApiOperation(value = "모든 댓글 불러오기", notes = "모든 게시물 부르기")
//    @GetMapping("/comments")
//    public ResponseEntity<?> selectAllComment(@RequestBody ArticleReq articleReq,
//                                              @PageableDefault(size = 15, sort = "likeCount", direction = Sort.Direction.DESC) Pageable pageable) {
//        return new ResponseEntity<>(commentService.selectAllComment(articleReq, pageable), HttpStatus.OK);
//    }

    /*
    댓글 수정
     */
    @ApiOperation(value = "댓글 수정", notes = "댓글 수정")
    @PutMapping("/comments/{commentId}")
    public ResponseEntity<?> updateArticle(Long userId, @PathVariable Long commentId, String content) {


        boolean check = commentService.updateComment(userId, commentId, content);
        if (!check) {
            return new ResponseEntity<>(FAIL, HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }

    /*
    댓글 삭제
     */
    @ApiOperation(value = "댓글 삭제", notes = "댓글 삭제")
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> deleteComment(Long userId, @PathVariable Long commentId) {

        boolean check = commentService.deleteComment(userId, commentId);

        if (!check) {
            return new ResponseEntity<>(FAIL, HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(SUCCESS, HttpStatus.OK);
    }
}
