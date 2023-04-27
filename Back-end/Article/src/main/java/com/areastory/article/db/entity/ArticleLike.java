package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
@IdClass(ArticleLikePK.class)
public class ArticleLike extends BaseTime {
    @Id
    @JoinColumn(name = "user_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Id
    @JoinColumn(name = "article_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Article article;

    public ArticleLike(User user, Article article) {
        this.user = user;
        this.article = article;
    }
}
