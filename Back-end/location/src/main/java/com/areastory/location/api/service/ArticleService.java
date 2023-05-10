package com.areastory.location.api.service;



import com.areastory.location.dto.common.ArticleKafkaDto;

import javax.transaction.Transactional;

public interface ArticleService {
    @Transactional
    void addArticle(ArticleKafkaDto articleKafkaDto);

    @Transactional
    void updateArticle(ArticleKafkaDto articleKafkaDto);

    @Transactional
    void deleteArticle(ArticleKafkaDto articleKafkaDto);
}
