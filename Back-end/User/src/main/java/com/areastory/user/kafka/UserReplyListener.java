package com.areastory.user.kafka;

import com.areastory.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserReplyListener {
    private final UserService userService;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_USER_REPLY, topics = KafkaProperties.USER_REPLY, containerFactory = "userReplyContainerFactory")
    public void articleListen(Long userId) {
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        userService.validateUser(userId);
        System.out.println("validated : " + userId);
    }
}
