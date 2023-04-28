package com.areastory.article.api.controller;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/articles/{articleId}")
public class CommentController {
    private final CommentService commentService;


    /*
    댓글 작성
     */
    @PostMapping("/comments")
    public ResponseEntity<?> writeComment(@PathVariable Long articleId, @RequestBody CommentWriteReq commentWriteReq) {
        commentWriteReq.setArticleId(articleId);
        commentService.addComment(commentWriteReq);
        return ResponseEntity.ok().build();
    }

    /*
    해당 게시글의 댓글 가져오기 => 게시글 자세히 가져올 때 댓글 리스트를 넣는데 모든 댓글을 부르는 게 필요할까?
     */
    @GetMapping("/comments")
    public ResponseEntity<?> selectAllComment(Long userId,
                                              @PathVariable Long articleId,
                                              @PageableDefault(size = 15, sort = "likeCount", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(commentService.selectAllComment(new CommentReq(userId, articleId), pageable));
    }

    /*
    댓글 수정
     */
    @PutMapping("/comments/{commentId}")
    public ResponseEntity<?> updateComment(Long userId, @PathVariable Long commentId, String content) {
        CommentUpdateDto commentUpdateDto = CommentUpdateDto.builder()
                .userId(userId)
                .commentId(commentId)
                .content(content)
                .build();

        boolean check = commentService.updateComment(commentUpdateDto);
        if (!check) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok().build();
    }

    /*
    댓글 삭제
     */
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> deleteComment(
            @PathVariable Long articleId, Long userId, @PathVariable Long commentId) {

        CommentDeleteDto commentDeleteDto = CommentDeleteDto.builder()
                .userId(userId)
                .commentId(commentId)
                .articleId(articleId)
                .build();
        boolean check = commentService.deleteComment(commentDeleteDto);

        if (!check) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok().build();
    }


    /*
    댓글 좋아요 누르기
     */
    @PostMapping("/comments/like/{commentId}")
    public ResponseEntity<?> addLike(@PathVariable Long commentId, Long userId) {
        if (!commentService.addCommentLike(userId, commentId)) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        return ResponseEntity.ok().build();
    }

    /*
    댓글 좋아요 취소
     */
    @DeleteMapping("/comments/like/{commentId}")
    public ResponseEntity<?> deleteLike(@PathVariable Long commentId, Long userId) {
        if (!commentService.deleteCommentLike(userId, commentId)) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        return ResponseEntity.ok().build();
    }
}
