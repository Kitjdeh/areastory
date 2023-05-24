package com.areastory.article.dto.response;

import com.areastory.article.dto.common.ChatMessageDto;
import com.areastory.article.dto.common.MessageType;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class ChatMessageEnterResp {
    private MessageType type;
    private String message;
    private Long userId;
    private String roomId;
    private String profile;
    private String nickname;
    private List<ChatMessageDto> messageList;
    private Long userCount;

}
