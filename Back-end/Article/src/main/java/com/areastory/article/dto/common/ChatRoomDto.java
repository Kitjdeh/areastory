package com.areastory.article.dto.common;

import lombok.Data;

@Data
public class ChatRoomDto {
    private String roomId;
    private String name;
    private Long userCount;

    public ChatRoomDto(String roomId, String name, Long userCount) {
        this.roomId = roomId;
        this.name = name;
        this.userCount = userCount;
    }
}
