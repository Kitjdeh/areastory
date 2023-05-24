package com.areastory.user.kafka;

import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.common.NotificationDto;
import com.areastory.user.dto.common.NotificationKafkaDto;
import com.areastory.user.service.NotificationService;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NotificationListener {
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    @KafkaListener(id = KafkaProperties.GROUP_NAME_NOTIFICATION, topics = KafkaProperties.TOPIC_NOTIFICATION, containerFactory = "notificationContainerFactory")
    public void notificationListen(NotificationKafkaDto notificationKafkaDto) {
        System.out.println("notification : " + notificationKafkaDto);
        String title = "";
        String body = "";
        switch (notificationKafkaDto.getType()) {
            case "comment":
                title = "작성한 게시글에 댓글이 달렸습니다!";
                body = notificationKafkaDto.getArticleContent();
                break;
            case "article-like":
                title = "작성한 게시글에 " + notificationKafkaDto.getOtherUsername() + "님께서 좋아요를 눌렀습니다!";
                body = notificationKafkaDto.getArticleContent();
                break;
            case "comment-like":
                title = "작성한 댓글에 " + notificationKafkaDto.getOtherUsername() + "님께서 좋아요를 눌렀습니다!";
                body = notificationKafkaDto.getCommentContent();
                break;
            case "follow":
                title = notificationKafkaDto.getOtherUsername() + "님께서 당신을 팔로우했습니다!";
                body = "터치하여 " + notificationKafkaDto.getOtherUsername() + "님에 대해 알아보세요";
                break;
        }

        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        System.out.println(notificationKafkaDto.getCreatedAt());
        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

        NotificationDto notificationDto = NotificationDto.builder()
                .title(title)
                .body(body)
                .createdAt(notificationKafkaDto.getCreatedAt())
                .articleId(notificationKafkaDto.getArticleId())
                .commentId(notificationKafkaDto.getCommentId())
                .userId(notificationKafkaDto.getUserId()) // 알람을 받은 사람
                .otherUserId(notificationKafkaDto.getOtherUserId())
                .type(notificationKafkaDto.getType())
                .build();
        notificationService.addNotification(notificationDto);
        //원래 여기 쓰면 안되는데 일단 리팩토링 전에 씀
        User user = userRepository.findById(notificationKafkaDto.getUserId()).orElseThrow();
        String registrationToken = user.getRegistrationToken();
        //상현
//        String registrationToken = "czYC8DJERUS2C6nwrqG_N8:APA91bH00MoGdSrmkVdcv0GTiGesWzlSrRtbw5k7xfPg3SPR1FSqeELXFGaQSgf_oUaH4EMJkbmkfkcfeVCvsPTnkTQkz6M21ecdj4Tr35pzeMWOO2O51OwDv0W3hNaxvL4FL7rcIDPX";
        //원준
//        String registrationToken = "eAv6-BfNRv6e9xl2y93M61:APA91bHSbiCUZBbd7AGHo8FWJP5Hzl57i_kxFou388kLwzwlz6883svCdCqaxdUFv3L1Nm_2TCLCkccSLgSZBbPW_fKz6T9fbE1tnqnUjrwWdMNoNWQtbMAdGwH4utMjlf0Y7YhpFpZP";
        Notification notification = Notification.builder().setTitle(title).setBody(body).build();
        System.out.println("token : " + registrationToken);
        Message message = Message.builder()
                .putData("type", notificationKafkaDto.getType())
                .putData("articleId", String.valueOf(notificationKafkaDto.getArticleId()))
                .putData("commentId", String.valueOf(notificationKafkaDto.getCommentId()))
                .putData("userId", String.valueOf(notificationKafkaDto.getUserId()))
                .putData("otherUserId", String.valueOf(notificationKafkaDto.getOtherUserId()))
                .setNotification(notification)
                .setToken(registrationToken)
//                            .setTopic("test")
                .build();

        // registration token.
        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
        // Response is a message ID string.
        System.out.println("Successfully sent message: " + response);
    }
}
