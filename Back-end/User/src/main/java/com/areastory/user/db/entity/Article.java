package com.areastory.user.db.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Article {

    @Id
    private Long articleId;
    @Setter
    private String content;
    private String image;
    @Setter
    private Long likeCount;
    @Setter
    private Long commentCount;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    private LocalDateTime createdAt;

    public Article(String content, String image, User user) {
        this.content = content;
        this.image = image;
        this.user = user;
    }
}
