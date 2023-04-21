package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Id;
import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class ArticleLikePK implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    private Long userId;
    @Id
    private Long articleId;

    public ArticleLikePK(Long userId, Long articleId) {
        this.userId = userId;
        this.articleId = articleId;
    }

}
