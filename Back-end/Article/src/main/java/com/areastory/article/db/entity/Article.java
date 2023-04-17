package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
public class Article extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long articleId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String content;
    private String image;
    private Long likeCount;
    private Long commentCount;

//    private List<Comment> comment;

    @OneToOne
    @JoinColumn(name = "locationId")
    private Location location;

    @Builder
    public Article(User user, String content, String image) {
        this.user = user;
        this.content = content;
        this.image = image;
    }

    public void updateContent(String content) {
        this.content = content;
    }

    public void updateImage(String image) {
        this.image = image;
    }
}
