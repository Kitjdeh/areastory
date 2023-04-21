package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.Comment;
import com.areastory.article.db.entity.CommentLike;
import com.areastory.article.db.entity.CommentLikePK;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.CommentLikeRepository;
import com.areastory.article.db.repository.CommentRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final ArticleRepository articleRepository;
    private final CommentLikeRepository commentLikeRepository;

    @Override
    @Transactional
    public void addComment(CommentWriteReq commentWriteReq) {
        //article commentCount 늘려주기 위함
        Article article = articleRepository.findById(commentWriteReq.getArticleId()).orElseThrow();
        article.addCommentCount();
        //comment 저장
        commentRepository.save(Comment.builder()
                .user(userRepository.findById(commentWriteReq.getUserId()).orElseThrow())
                .content(commentWriteReq.getContent())
                .articleId(commentWriteReq.getArticleId())
                .build());
    }

    @Override
    public CommentResp selectAllComment(CommentReq commentReq, Pageable pageable) {
        //article에 있는 comment 불러오기
        Page<CommentDto> comments = commentRepository.findAll(commentReq, pageable);
        return CommentResp.builder()
                .comments(comments.getContent())
                .pageSize(comments.getPageable().getPageSize())
                .totalPageNumber(comments.getTotalPages())
                .totalCount(comments.getTotalElements())
                .build();
    }

    @Override
    public boolean updateComment(Long userId, Long commentId, String content) {
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        if (!Objects.equals(comment.getUser().getUserId(), userId)) {
            return false;
        }
        comment.updateContent(content);
        return true;
    }

    @Override
    public boolean deleteComment(Long userId, Long commentId) {
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        if (!Objects.equals(comment.getUser().getUserId(), userId)) {
            return false;
        }
        commentRepository.delete(comment);
        return true;
    }

    @Override
    public boolean addCommentLike(Long userId, Long commentId) {
        if (commentLikeRepository.existsById(new CommentLikePK(userId, commentId)))
            return false;
        commentLikeRepository.save(new CommentLike(userId, commentId));
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        comment.addLikeCount();
        return true;
    }

    @Override
    public boolean deleteCommentLike(Long userId, Long commentId) {
        if (!commentLikeRepository.existsById(new CommentLikePK(userId, commentId)))
            return false;
        commentLikeRepository.delete(new CommentLike(userId, commentId));
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        comment.removeLikeCount();
        return true;
    }

}
