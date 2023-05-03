package com.areastory.article.dto.common;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatMessageDto {
    private String roomId; // 방번호
    private Long userId; // 발신자 PK
    private String nickname;
    private String profile;
    private String content; // 메시지

    public ChatMessageDto(String roomId, Long userId, String nickname, String profile, String content) {
        this.roomId = roomId;
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
    }
}
