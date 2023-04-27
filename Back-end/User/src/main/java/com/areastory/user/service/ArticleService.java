package com.areastory.user.service;

import com.areastory.user.dto.common.ArticleKafkaDto;

import javax.transaction.Transactional;

public interface ArticleService {
    @Transactional
    void addArticle(ArticleKafkaDto articleKafkaDto);

    @Transactional
    void updateArticle(ArticleKafkaDto articleKafkaDto);

    @Transactional
    void deleteArticle(ArticleKafkaDto articleKafkaDto);
}
