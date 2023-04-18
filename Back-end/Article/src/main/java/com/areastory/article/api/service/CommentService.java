package com.areastory.article.api.service;

import com.areastory.article.dto.request.CommentReq;

public interface CommentService {

    void addComment(CommentReq commentReq);

    boolean updateComment(Long userId, Long commentId, String content);

    boolean deleteComment(Long userId, Long commentId);
}
