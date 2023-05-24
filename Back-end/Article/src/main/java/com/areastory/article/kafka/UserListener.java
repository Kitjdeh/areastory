package com.areastory.article.kafka;

import com.areastory.article.api.service.FollowService;
import com.areastory.article.api.service.UserService;
import com.areastory.article.dto.common.FollowKafkaDto;
import com.areastory.article.dto.common.UserKafkaDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class UserListener {
    private final UserService userService;
    private final UserReplyProducer userReplyProducer;
    private final FollowService followService;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_USER, topics = KafkaProperties.TOPIC_USER, containerFactory = "userContainerFactory")
    public void userListen(UserKafkaDto userKafkaDto) {
        System.out.println(userKafkaDto);
        switch (userKafkaDto.getType()) {
            case KafkaProperties.INSERT:
                userService.addUser(userKafkaDto);
                userReplyProducer.send(userKafkaDto.getUserId());
                break;
            case KafkaProperties.UPDATE:
                userService.updateUser(userKafkaDto);
                break;
            case KafkaProperties.DELETE:
                userService.deleteUser(userKafkaDto);
                break;
        }
    }

    @KafkaListener(id = KafkaProperties.GROUP_NAME_FOLLOW, topics = KafkaProperties.TOPIC_FOLLOW, containerFactory = "followContainerFactory")
    public void followListen(FollowKafkaDto followKafkaDto) {
        System.out.println(followKafkaDto);
        switch (followKafkaDto.getType()) {
            case KafkaProperties.INSERT:
                followService.addFollow(followKafkaDto);
                break;
            case KafkaProperties.DELETE:
                followService.deleteFollow(followKafkaDto);
                break;
        }
    }
}
