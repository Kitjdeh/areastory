package com.areastory.article.db.repository.custom;

import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.request.CommentReq;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CommentCustomRepository {
    Page<CommentDto> findAll(CommentReq commentReq, Pageable pageable);
}
