package com.areastory.article.api.service;

import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import com.areastory.article.dto.response.LikeResp;
import org.springframework.data.domain.Pageable;

public interface CommentService {

    void addComment(CommentWriteReq commentWriteReq);

    CommentResp selectAllComment(CommentReq commentReq, Pageable pageable);

    void updateComment(CommentUpdateDto commentUpdateDto);

    void deleteComment(CommentDeleteDto commentDeleteDto);

    void addCommentLike(Long userId, Long commentId);

    void deleteCommentLike(Long userId, Long commentId);

    LikeResp selectAllLikeList(Long userId, Long commentId, Pageable pageable);

    CommentResp selectMyCommentList(Long userId, Pageable pageable);

    CommentDto selectComment(Long commentId, Long userId);
}
