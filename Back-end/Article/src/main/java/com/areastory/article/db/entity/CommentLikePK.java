package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Id;
import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class CommentLikePK implements Serializable {
    @Id
    private Long userId;

    @Id
    private Long commentId;

    public CommentLikePK(Long userId, Long commentId) {
        this.userId = userId;
        this.commentId = commentId;
    }
}
