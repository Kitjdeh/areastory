package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.Comment;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.CommentRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.request.CommentReq;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final ArticleRepository articleRepository;

    @Override
    @Transactional
    public void addComment(CommentReq commentReq) {
        Article article = articleRepository.findById(commentReq.getArticleId()).get();
        article.updateCommentCount();
        commentRepository.save(Comment.builder()
                .user(userRepository.findById(commentReq.getUserId()).get())
                .content(commentReq.getContent())
                .article(article)
                .build());
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


}
