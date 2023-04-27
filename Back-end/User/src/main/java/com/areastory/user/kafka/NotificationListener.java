package com.areastory.user.kafka;

import com.areastory.user.dto.common.NotificationKafkaDto;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class NotificationListener {
    @KafkaListener(id = KafkaProperties.GROUP_NAME_NOTIFICATION, topics = KafkaProperties.TOPIC_NOTIFICATION, containerFactory = "notificationContainerFactory")
    public void articleListen(NotificationKafkaDto notificationKafkaDto) {
        System.out.println("notification : " + notificationKafkaDto);
    }
}
