package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
@IdClass(ChattingPK.class)
public class Chatting {
    @Id
    @JoinColumn(name = "user_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Id
    @JoinColumn(name = "room_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private ChatRoom chatRoom;

    public Chatting(User user, ChatRoom chatRoom) {
        this.user = user;
        this.chatRoom = chatRoom;
    }
}
