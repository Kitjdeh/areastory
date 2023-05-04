package com.areastory.article.api.service;

import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import com.areastory.article.dto.response.LikeResp;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.data.domain.Pageable;

public interface CommentService {

    void addComment(CommentWriteReq commentWriteReq) throws JsonProcessingException;

    CommentResp selectAllComment(CommentReq commentReq, Pageable pageable);

    void updateComment(CommentUpdateDto commentUpdateDto);

    void deleteComment(CommentDeleteDto commentDeleteDto);

    void addCommentLike(Long userId, Long commentId) throws JsonProcessingException;

    void deleteCommentLike(Long userId, Long commentId);

    LikeResp selectAllLikeList(Long userId, Long commentId, Pageable pageable);

    CommentResp selectMyLikeList(Long userId, Pageable pageable);
}
