package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class ArticleLikePK implements Serializable {
    private Long user;
    private Long article;

    public ArticleLikePK(Long user, Long article) {
        this.user = user;
        this.article = article;
    }

}
