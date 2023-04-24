package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;

@Entity
@Getter
@NoArgsConstructor
@IdClass(ArticleLikePK.class)
public class ArticleLike extends BaseTime {
    @Id
    private Long userId;
    @Id
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Long articleId;

    public ArticleLike(Long userId, Long articleId) {
        this.userId = userId;
        this.articleId = articleId;
    }
}
