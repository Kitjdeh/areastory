package com.areastory.article.dto.response;

import com.areastory.article.dto.common.MessageType;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class ChatMessageQuitResp {
    private MessageType type;
    private Long userId;
    private String roomId;
    private String profile;
    private String nickname;
    private String message;
    private Long userCount;
}
