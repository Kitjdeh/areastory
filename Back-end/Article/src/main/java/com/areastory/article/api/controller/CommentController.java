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
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/articles/{articleId}/comments")
public class CommentController {
    private final CommentService commentService;

    /*
    댓글 작성
     */
    @PostMapping
    public ResponseEntity<?> writeComment(@PathVariable Long articleId, @RequestBody CommentWriteReq commentWriteReq) {
        commentWriteReq.setArticleId(articleId);
        commentService.addComment(commentWriteReq);
        return ResponseEntity.ok().build();
    }

    /*
    해당 게시글의 댓글들 가져오기
     */
    @GetMapping
    public ResponseEntity<?> selectAllComment(Long userId,
                                              @PathVariable Long articleId,
                                              @PageableDefault(size = 15, sort = "commentId", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(commentService.selectAllComment(new CommentReq(userId, articleId), pageable));
    }

    /*
    댓글 상세 가져오기
     */
    @GetMapping("/{commentId}")
    public ResponseEntity<?> selectComment(@PathVariable Long commentId, Long userId) {
        return ResponseEntity.ok(commentService.selectComment(commentId, userId));
    }

    /*
    댓글 수정
     */
    @PatchMapping("/{commentId}")
    public ResponseEntity<?> updateComment(Long userId, @PathVariable Long commentId, String content) {
        CommentUpdateDto commentUpdateDto = CommentUpdateDto.builder()
                .userId(userId)
                .commentId(commentId)
                .content(content)
                .build();

        commentService.updateComment(commentUpdateDto);
        return ResponseEntity.ok().build();
    }

    /*
    댓글 삭제
     */
    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(
            @PathVariable Long articleId, Long userId, @PathVariable Long commentId) {

        CommentDeleteDto commentDeleteDto = CommentDeleteDto.builder()
                .userId(userId)
                .commentId(commentId)
                .articleId(articleId)
                .build();
        commentService.deleteComment(commentDeleteDto);
        return ResponseEntity.ok().build();
    }


    /*
    댓글 좋아요 누르기
     */
    @PostMapping("/like/{commentId}")
    public ResponseEntity<?> addLike(@PathVariable Long commentId, Long userId) {
        commentService.addCommentLike(userId, commentId);
        return ResponseEntity.ok().build();
    }

    /*
    댓글 좋아요 취소
     */
    @DeleteMapping("/like/{commentId}")
    public ResponseEntity<?> deleteLike(@PathVariable Long commentId, Long userId) {
        commentService.deleteCommentLike(userId, commentId);
        return ResponseEntity.ok().build();
    }

    /*
   해당 댓글에 좋아요 누른 사람들 목록 보기
    */
    @GetMapping("/like/{commentId}")
    public ResponseEntity<?> getLikeList(@PathVariable Long commentId, Long userId,
                                         @PageableDefault(size = 15) Pageable pageable) {
        return ResponseEntity.ok(commentService.selectAllLikeList(userId, commentId, pageable));
    }

    /*
    내가 단 댓글 목록 보기
    */
    @GetMapping("/myComment/{userId}")
    public ResponseEntity<?> getMyLikeList(@PathVariable Long userId,
                                           @PageableDefault(sort = "commentId", direction = Sort.Direction.DESC, size = 15) Pageable pageable) {
        return ResponseEntity.ok(commentService.selectMyCommentList(userId, pageable));
    }
}
