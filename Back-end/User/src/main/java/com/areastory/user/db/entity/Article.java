package com.areastory.user.db.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Article extends ArticleBaseTime {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "article_id")
    private Long articleId;
    private String content;
    private String image;
    private Long like_count;
    private Long comment_count;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User userId;

    public Article(String content, String image, User user) {
        this.content = content;
        this.image = image;
        this.userId = user;
    }
}
