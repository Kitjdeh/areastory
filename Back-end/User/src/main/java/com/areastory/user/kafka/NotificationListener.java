package com.areastory.user.kafka;

import com.areastory.user.dto.common.NotificationKafkaDto;
import com.areastory.user.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NotificationListener {
    private final NotificationService notificationService;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_NOTIFICATION, topics = KafkaProperties.TOPIC_NOTIFICATION, containerFactory = "notificationContainerFactory")
    public void notificationListen(NotificationKafkaDto notificationKafkaDto) {
        notificationService.addNotification(notificationKafkaDto);
        System.out.println("notification : " + notificationKafkaDto);
    }
}
