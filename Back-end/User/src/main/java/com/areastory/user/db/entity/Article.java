package com.areastory.user.db.entity;

import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Table(name = "article"
//        , indexes = @Index(name = "idx_user_id", columnList = "user_id, article_id")
)
public class Article {

    @Id
    @Column(name = "article_id")
    private Long articleId;
    @Setter
    @Column(length = 100)
    private String content;
    @Column(length = 200)
    private String image;
    @Setter
    private Long commentCount;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;
    private LocalDateTime createdAt;
    @Setter
    private Boolean publicYn;

    public Article(String content, LocalDateTime createdAt, String image, User user, boolean publicYn) {
        this.content = content;
        this.createdAt = createdAt;
        this.image = image;
        this.user = user;
        this.publicYn = publicYn;
    }
}
