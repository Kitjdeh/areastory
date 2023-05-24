package com.areastory.article.db.entity;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@NoArgsConstructor
@EqualsAndHashCode
public class FollowPK implements Serializable {
    private Long followUser;

    private Long followingUser;

    public FollowPK(Long followUser, Long followingUser) {
        this.followUser = followUser;
        this.followingUser = followingUser;
    }
}
