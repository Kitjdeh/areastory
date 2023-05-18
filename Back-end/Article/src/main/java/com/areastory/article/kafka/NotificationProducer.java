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
                .userId(articleLike.getArticle().getUser().getUserId()) // 게시글 작성자
                .username(articleLike.getArticle().getUser().getNickname())
                .otherUserId(articleLike.getUser().getUserId()) // 좋아요 누른 사람
                .otherUsername(articleLike.getUser().getNickname())
                .articleId(articleLike.getArticle().getArticleId())
                .articleContent(articleLike.getArticle().getContent())
                .image(articleLike.getArticle().getImage())
                .createdAt(articleLike.getCreatedAt())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, articleLikeNotificationKafkaDto.getUserId(), articleLikeNotificationKafkaDto));
    }

    public void send(Comment comment) {
        NotificationKafkaDto commentNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.COMMENT)
                .userId(comment.getArticle().getUser().getUserId())
                .username(comment.getArticle().getUser().getNickname())
                .otherUserId(comment.getUser().getUserId())
                .otherUsername(comment.getUser().getNickname())
                .articleId(comment.getArticle().getArticleId())
                .articleContent(comment.getArticle().getContent())
                .commentId(comment.getCommentId())
                .commentContent(comment.getContent())
                .image(comment.getArticle().getImage())
                .createdAt(comment.getCreatedAt())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, commentNotificationKafkaDto.getUserId(), commentNotificationKafkaDto));
    }

    public void send(CommentLike commentLike) {
        NotificationKafkaDto commentLikeNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.COMMENT_LIKE)
                .otherUserId(commentLike.getUser().getUserId())
                .otherUsername(commentLike.getUser().getNickname())
                .userId(commentLike.getComment().getUser().getUserId())
                .username(commentLike.getComment().getUser().getNickname())
                .articleId(commentLike.getComment().getArticle().getArticleId())
                .articleContent(commentLike.getComment().getArticle().getContent())
                .commentId(commentLike.getComment().getCommentId())
                .commentContent(commentLike.getComment().getContent())
                .image(commentLike.getComment().getArticle().getImage())
                .createdAt(commentLike.getCreatedAt())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, commentLikeNotificationKafkaDto.getUserId(), commentLikeNotificationKafkaDto));
    }
}
