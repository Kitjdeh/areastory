package com.areastory.article.dto.common;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ChatMessageDto {
    private MessageType type; // 메시지 타입
    private String roomId; // 방번호
    private String sender; // 메시지 보낸사람
    private String content; // 메시지
    private Long userCount; // 채팅방 인원수

    // 메시지 타입 : 입장, 채팅
    public enum MessageType {
        TALK, QUIT, ENTER
    }
}

