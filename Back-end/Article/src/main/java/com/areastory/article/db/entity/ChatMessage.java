package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@NoArgsConstructor
@Getter
public class ChatMessage extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chatId;

    private String sender; //보내는 사람 -> 추후 user로 변경

    @Column(columnDefinition = "TEXT")
    private String content;


    private String roomId;

    @Builder
    public ChatMessage(String sender, String content, String roomeId) {
        this.sender = sender;
        this.content = content;
        this.roomId = roomeId;
    }
}

