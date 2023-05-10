package com.areastory.article.dto.request;

import com.areastory.article.dto.common.MessageType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class ChatMessageReq {
    private MessageType type; // 메시지 타입
    private String roomId; // 방번호
    private Long userId; // 발신자 PK
    private String content; // 메시지

}

