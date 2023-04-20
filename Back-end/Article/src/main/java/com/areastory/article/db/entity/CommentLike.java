package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Entity
@Getter
@NoArgsConstructor
public class CommentLike implements Serializable {
    @Id
    private Long userId;

    @Id
    private Long commentId;

    public CommentLike(Long userId, Long commentId) {
        this.userId = userId;
        this.commentId = commentId;
    }
}
