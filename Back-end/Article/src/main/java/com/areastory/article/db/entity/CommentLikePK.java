package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class CommentLikePK implements Serializable {
    private Long user;

    private Long comment;

    public CommentLikePK(Long user, Long comment) {
        this.user = user;
        this.comment = comment;
    }
}
