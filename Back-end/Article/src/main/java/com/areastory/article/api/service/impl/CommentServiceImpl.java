package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.db.entity.*;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.CommentLikeRepository;
import com.areastory.article.db.repository.CommentRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import com.areastory.article.dto.response.LikeResp;
import com.areastory.article.exception.CustomException;
import com.areastory.article.exception.ErrorCode;
import com.areastory.article.kafka.ArticleProducer;
import com.areastory.article.kafka.KafkaProperties;
import com.areastory.article.kafka.NotificationProducer;
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
    private final NotificationProducer notificationProducer;
    private final ArticleProducer articleProducer;

    @Override
    @Transactional
    public void addComment(CommentWriteReq commentWriteReq) {
        //article commentCount 늘려주기 위함
        Article article = articleRepository.findById(commentWriteReq.getArticleId()).orElseThrow(() -> new CustomException(ErrorCode.ARTICLE_NOT_FOUND));
        article.addCommentCount();
        //comment 저장
        Comment comment = commentRepository.save(Comment.builder()
                .user(userRepository.findById(commentWriteReq.getUserId()).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND)))
                .content(commentWriteReq.getContent())
                .article(article)
                .build());
        notificationProducer.send(comment);
        articleProducer.send(article, KafkaProperties.UPDATE);
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
                .pageNumber(comments.getPageable().getPageNumber() + 1)
                .nextPage(comments.hasNext())
                .previousPage(comments.hasPrevious())
                .build();
    }

    @Override
    @Transactional
    public void updateComment(CommentUpdateDto commentUpdateDto) {
        Comment comment = commentRepository.findById(commentUpdateDto.getCommentId()).orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));
        if (!Objects.equals(comment.getUser().getUserId(), commentUpdateDto.getUserId())) {
            throw new CustomException(ErrorCode.UNAUTHORIZED_REQUEST);
        }
        comment.updateContent(commentUpdateDto.getContent());
    }

    @Override
    @Transactional
    public void deleteComment(CommentDeleteDto commentDeleteDto) {
        //comment 불러오기
        Comment comment = commentRepository.findById(commentDeleteDto.getCommentId()).orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));
        //comment 쓴사람 아니면 예외처리
        if (!Objects.equals(comment.getUser().getUserId(), commentDeleteDto.getUserId())) {
            throw new CustomException(ErrorCode.UNAUTHORIZED_REQUEST);
        }
        //article commentCount 줄이기 위함
        Article article = articleRepository.findById(commentDeleteDto.getArticleId()).orElseThrow(() -> new CustomException(ErrorCode.ARTICLE_NOT_FOUND));
        article.deleteCommentCount();
        //comment 삭제하기
        commentRepository.deleteById(comment.getCommentId());
        articleProducer.send(article, KafkaProperties.UPDATE);
    }

    @Override
    @Transactional
    public void addCommentLike(Long userId, Long commentId) {
        if (commentLikeRepository.existsById(new CommentLikePK(userId, commentId))) {
            throw new CustomException(ErrorCode.DUPLICATE_RESOURCE);
        }
        User user = userRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));
        Comment comment = commentRepository.findById(commentId).orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));
        CommentLike commentLike = commentLikeRepository.save(new CommentLike(user, comment));
        comment.addLikeCount();
        notificationProducer.send(commentLike);
    }

    @Override
    @Transactional
    public void deleteCommentLike(Long userId, Long commentId) {
        if (!commentLikeRepository.existsById(new CommentLikePK(userId, commentId))) {
            throw new CustomException(ErrorCode.LIKE_NOT_FOUND);
        }
        User user = userRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));
        Comment comment = commentRepository.findById(commentId).orElseThrow(() -> new CustomException(ErrorCode.COMMENT_NOT_FOUND));
        commentLikeRepository.delete(new CommentLike(user, comment));
        comment.removeLikeCount();
    }

    @Override
    public LikeResp selectAllLikeList(Long userId, Long commentId, Pageable pageable) {
        Page<UserDto> likes = commentRepository.findAllLike(userId, commentId, pageable);
        return LikeResp.builder()
                .users(likes.getContent())
                .pageSize(likes.getPageable().getPageSize())
                .totalPageNumber(likes.getTotalPages())
                .totalCount(likes.getTotalElements())
                .pageNumber(likes.getPageable().getPageNumber() + 1)
                .nextPage(likes.hasNext())
                .previousPage(likes.hasPrevious())
                .build();
    }

    @Override
    public CommentResp selectMyCommentList(Long userId, Pageable pageable) {
        Page<CommentDto> comments = commentRepository.findMyCommentList(userId, pageable);

        return CommentResp.builder()
                .comments(comments.getContent())
                .pageSize(comments.getPageable().getPageSize())
                .totalPageNumber(comments.getTotalPages())
                .totalCount(comments.getTotalElements())
                .pageNumber(comments.getPageable().getPageNumber() + 1)
                .nextPage(comments.hasNext())
                .previousPage(comments.hasPrevious())
                .build();
    }

    @Override
    public CommentDto selectComment(Long commentId, Long userId) {
        return commentRepository.findOne(commentId, userId);
    }


}
