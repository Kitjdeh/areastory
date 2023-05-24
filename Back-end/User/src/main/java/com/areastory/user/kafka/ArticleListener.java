package com.areastory.user.kafka;

import com.areastory.user.dto.common.ArticleKafkaDto;
import com.areastory.user.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ArticleListener {
    private final ArticleService articleService;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_ARTICLE, topics = KafkaProperties.TOPIC_ARTICLE, containerFactory = "articleContainerFactory")
    public void articleListen(ArticleKafkaDto articleKafkaDto) {
        switch (articleKafkaDto.getType()) {
            case KafkaProperties.INSERT:
                articleService.addArticle(articleKafkaDto);
                break;
            case KafkaProperties.UPDATE:
                articleService.updateArticle(articleKafkaDto);
                break;
            case KafkaProperties.DELETE:
                articleService.deleteArticle(articleKafkaDto);
                break;
        }
    }
}
