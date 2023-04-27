package com.areastory.article.kafka;

import com.areastory.article.db.entity.ArticleLike;
import com.areastory.article.db.entity.Comment;
import com.areastory.article.db.entity.CommentLike;
import com.areastory.article.dto.common.NotificationKafkaDto;
import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NotificationProducer {
    private final KafkaTemplate<Long, NotificationKafkaDto> kafkaTemplate;
    public void send(ArticleLike articleLike) {
        NotificationKafkaDto articleLikeNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.ARTICLE_LIKE)
                .nickname(articleLike.getUser().getNickname())
                .profile(articleLike.getUser().getProfile())
                .articleId(articleLike.getArticle().getArticleId())
                .image(articleLike.getArticle().getImage())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, articleLike.getArticle().getUser().getUserId(), articleLikeNotificationKafkaDto));
    }
    public void send(Comment comment) {
        NotificationKafkaDto commentNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.COMMENT)
                .nickname(comment.getUser().getNickname())
                .profile(comment.getUser().getProfile())
                .articleId(comment.getArticle().getArticleId())
                .commentId(comment.getCommentId())
                .image(comment.getArticle().getImage())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, comment.getArticle().getUser().getUserId(), commentNotificationKafkaDto));
    }
    public void send(CommentLike commentLike) {
        NotificationKafkaDto commentLikeNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.COMMENT_LIKE)
                .nickname(commentLike.getComment().getUser().getNickname())
                .profile(commentLike.getComment().getUser().getProfile())
                .articleId(commentLike.getComment().getArticle().getArticleId())
                .commentId(commentLike.getComment().getCommentId())
                .image(commentLike.getComment().getArticle().getImage())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, commentLike.getComment().getArticle().getUser().getUserId(), commentLikeNotificationKafkaDto));
    }
}
