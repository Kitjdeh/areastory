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
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
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
        Article article = articleRepository.findById(commentWriteReq.getArticleId()).orElseThrow();
        article.addCommentCount();
        //comment 저장
        Comment comment = commentRepository.save(Comment.builder()
                .user(userRepository.findById(commentWriteReq.getUserId()).orElseThrow())
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
                .build();
    }

    @Override
    @Transactional
    public boolean updateComment(CommentUpdateDto commentUpdateDto) {
        Comment comment = commentRepository.findById(commentUpdateDto.getCommentId()).orElseThrow();
        if (!Objects.equals(comment.getUser().getUserId(), commentUpdateDto.getUserId())) {
            return false;
        }
        comment.updateContent(commentUpdateDto.getContent());
        return true;
    }

    @Override
    @Transactional
    public boolean deleteComment(CommentDeleteDto commentDeleteDto) {
        //comment 불러오기
        Comment comment = commentRepository.findById(commentDeleteDto.getCommentId()).orElseThrow();
        //comment 쓴사람 아니면 false 리턴
        if (!Objects.equals(comment.getUser().getUserId(), commentDeleteDto.getUserId())) {
            return false;
        }
        //article commentCount 줄이기 위함
        Article article = articleRepository.findById(commentDeleteDto.getArticleId()).orElseThrow();
        article.deleteCommentCount();
        //comment 삭제하기
        commentRepository.deleteById(comment.getCommentId());
        articleProducer.send(article, KafkaProperties.UPDATE);
        return true;
    }

    @Override
    @Transactional
    public boolean addCommentLike(Long userId, Long commentId) {
        User user = userRepository.findById(userId).orElseThrow();
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        if (commentLikeRepository.existsById(new CommentLikePK(user.getUserId(), comment.getCommentId())))
            return false;
        CommentLike commentLike = new CommentLike(user, comment);
        commentLike = commentLikeRepository.save(commentLike);
        comment.addLikeCount();
        notificationProducer.send(commentLike);
        return true;
    }

    @Override
    @Transactional
    public boolean deleteCommentLike(Long userId, Long commentId) {
        User user = userRepository.findById(userId).orElseThrow();
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        if (!commentLikeRepository.existsById(new CommentLikePK(user.getUserId(), comment.getCommentId())))
            return false;

        commentLikeRepository.delete(new CommentLike(user, comment));
        comment.removeLikeCount();
        return true;
    }

}
