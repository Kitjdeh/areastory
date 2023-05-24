package com.areastory.article.api.controller;

import com.areastory.article.api.service.ChatMessageService;
import com.areastory.article.dto.common.MessageType;
import com.areastory.article.dto.request.ChatMessageReq;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.GetMapping;
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
    public void message(ChatMessageReq message) {
        /*
        채팅방의 인원수를 하나 증가
         */
        if (MessageType.ENTER.equals(message.getType())) {
            messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), chatService.enterRoom(message));

        }
        /*
        퇴장
        1. 방 참가 인원 감소
         */
        else if (MessageType.QUIT.equals(message.getType())) {
            messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), chatService.outRoom(message));
        }
        /*
        대화
        1. 대화 내용 저장하기 => 추후 배치를 이용해 저장
        2. 메세지 내용 해당 방을 구독한 사람들에게 전부 보내기
        3. 채팅방 lastChatDate 갱신
         */
        else if (MessageType.TALK.equals(message.getType())) {
            messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), chatService.saveMessage(message));
        }
    }

    /*
    자신이 구독한 채팅방 리스트 보여주기
     */
    @GetMapping("/chat/rooms")
    public ResponseEntity<?> selectAllRooms(Long userId,
                                            @PageableDefault(size = 15, sort = "lastChatDate", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(chatService.findAllRoom(userId, pageable));

    }
}
