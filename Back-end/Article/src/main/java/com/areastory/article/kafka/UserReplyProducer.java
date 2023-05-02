package com.areastory.article.kafka;

import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserReplyProducer {
    private final KafkaTemplate<Long, Long> userReplyTemplate;

    public void send(Long userId) {
        userReplyTemplate.send(new ProducerRecord<>(KafkaProperties.USER_REPLY, userId, userId));
    }
}
