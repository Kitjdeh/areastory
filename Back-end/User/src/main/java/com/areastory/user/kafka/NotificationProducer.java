package com.areastory.user.kafka;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.User;
import com.areastory.user.dto.common.NotificationKafkaDto;
import lombok.RequiredArgsConstructor;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NotificationProducer {
    private final KafkaTemplate<Long, NotificationKafkaDto> kafkaTemplate;

    public void send(Follow follow) {
        User followerUser = follow.getFollowerUser();
        User followingUser = follow.getFollowingUser();
        NotificationKafkaDto followNotificationKafkaDto = NotificationKafkaDto.builder()
                .type(KafkaProperties.FOLLOW)
                .userId(followingUser.getUserId())
                .username(followingUser.getNickname())
                .otherUserId(followerUser.getUserId())
                .otherUsername(followerUser.getNickname())
                .createdAt(follow.getCreatedAt())
                .build();
        kafkaTemplate.send(new ProducerRecord<>(KafkaProperties.TOPIC_NOTIFICATION, followerUser.getUserId(), followNotificationKafkaDto));
    }
}
