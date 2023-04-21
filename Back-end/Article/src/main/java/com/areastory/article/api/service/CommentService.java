package com.areastory.article.api.service;

import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import org.springframework.data.domain.Pageable;

public interface CommentService {

    void addComment(CommentWriteReq commentWriteReq);

    CommentResp selectAllComment(CommentReq commentReq, Pageable pageable);

    boolean updateComment(CommentUpdateDto commentUpdateDto);

    boolean deleteComment(CommentDeleteDto commentDeleteDto);

    boolean addCommentLike(Long userId, Long commentId);

    boolean deleteCommentLike(Long userId, Long commentId);
}
