package com.areastory.article.dto.common;

import lombok.Data;

@Data
public class ChatRoomDto {
    private String roomId;
    private String name;

    public ChatRoomDto(String roomId, String name) {
        this.roomId = roomId;
        this.name = name;
    }
}
