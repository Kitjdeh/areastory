package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.Article;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.ArticleRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.common.ArticleKafkaDto;
import com.areastory.user.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@RequiredArgsConstructor
public class
ArticleServiceImpl implements ArticleService {
    private final ArticleRepository articleRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public void addArticle(ArticleKafkaDto articleKafkaDto) {
        User user = userRepository.findById(articleKafkaDto.getUserId()).orElseThrow();
        Article article = Article.builder()
                .articleId(articleKafkaDto.getArticleId())
                .content(articleKafkaDto.getContent())
                .image(articleKafkaDto.getThumbnail())
                .commentCount(articleKafkaDto.getCommentCount())
                .user(user)
                .createdAt(articleKafkaDto.getCreatedAt())
                .publicYn(articleKafkaDto.getPublicYn())
                .build();

        articleRepository.save(article);
    }

    @Override
    @Transactional
    public void updateArticle(ArticleKafkaDto articleKafkaDto) {
        Article article = articleRepository.findById(articleKafkaDto.getArticleId()).orElseThrow();
        articleRepository.save(article);
        article.setContent(articleKafkaDto.getContent());
        article.setCommentCount(articleKafkaDto.getCommentCount());
        article.setPublicYn(articleKafkaDto.getPublicYn());
    }

    @Override
    @Transactional
    public void deleteArticle(ArticleKafkaDto articleKafkaDto) {
        articleRepository.deleteById(articleKafkaDto.getArticleId());
    }
}
