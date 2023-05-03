package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class ChattingPK implements Serializable {
    private Long user;

    private String chatRoom;

    public ChattingPK(Long user, String chatRoom) {
        this.user = user;
        this.chatRoom = chatRoom;
    }
}
