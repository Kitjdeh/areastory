package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
public class Comment extends BaseTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long commentId;

    private String content;
    private Long likeCount;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

//    @ManyToOne
//    @JoinColumn(name = "article_id")
//    private Article article;

    private Long articleId;

    @Builder
    public Comment(String content, User user, Long articleId) {
        this.content = content;
        this.user = user;
        this.articleId = articleId;
    }

    public void updateContent(String content) {
        this.content = content;
    }
}
