package com.areastory.article.api.controller;

import com.areastory.article.api.service.ChatMessageService;
import com.areastory.article.dto.common.ChatMessageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ChatController {
    /*
    /sub/chat/room/{roomId} -> 구독
    /pub/chat/message -> 발행
     */
    private final SimpMessageSendingOperations messagingTemplate;
    private final ChatMessageService chatService;

    //입장, 대화, 나가기의 값에 따라 서비스 처리
    @MessageMapping("/chat/message")
    public void message(ChatMessageDto message) {
        System.out.println("메세지 종류>>> " + message.getType());
        //입장
        if (ChatMessageDto.MessageType.ENTER.equals(message.getType())) {

            message.setContent(message.getSender() + "님이 입장하셨습니다.");

        }
        /*
        퇴장
        1. 방 참가 인원 DB에서 삭제
         */
        else if (ChatMessageDto.MessageType.QUIT.equals(message.getType())) {

            message.setContent(message.getSender() + "님이 퇴장하셨습니다.");
        }
        /*
        대화
        1. 대화 내용 저장하기 => 추후 배치를 이용해 저장
        2. 메세지 내용 해당 방을 구독한 사람들에게 전부 보내기
         */
        else if (ChatMessageDto.MessageType.TALK.equals(message.getType())) {

            chatService.save(message);
            message.setContent(message.getContent());
        }
        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), message);
    }
}
