package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
@Getter
public class ChatRoom {
    @Id
    private String roomId;

    private String roomName;
    private Long userCount;
    private LocalDateTime lastChatDate;

    public ChatRoom(String roomId, String roomName) {
        this.roomId = roomId;
        this.roomName = roomName;
    }

    public void updateUserCount() {
        this.userCount++;
    }

    public void deleteUserCount() {
        this.userCount--;
    }

    public void updateLastChatDate() {
        this.lastChatDate = LocalDateTime.now();
    }
}
