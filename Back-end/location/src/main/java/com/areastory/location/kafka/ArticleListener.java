package com.areastory.location.kafka;

import com.areastory.location.api.service.ArticleService;
import com.areastory.location.dto.common.ArticleKafkaDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ArticleListener {
    private final ArticleService articleService;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_ARTICLE, topics = KafkaProperties.TOPIC_ARTICLE, containerFactory = "articleContainerFactory")
    public void articleListen(ArticleKafkaDto articleKafkaDto) {
        System.out.println("articleKafkaDto: " + articleKafkaDto);
        System.out.println("리스너 리슨 : " + articleKafkaDto.getDailyLikeCount());
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
