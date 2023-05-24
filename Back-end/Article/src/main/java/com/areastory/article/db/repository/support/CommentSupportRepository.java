package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.CommentReq;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CommentSupportRepository {
    Page<CommentDto> findAll(CommentReq commentReq, Pageable pageable);

    CommentDto findOne(Long commentId, Long userId);

    Page<UserDto> findAllLike(Long userId, Long commentId, Pageable pageable);

    Page<CommentDto> findMyCommentList(Long userId, Pageable pageable);
}
