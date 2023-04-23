package com.areastory.user.db.entity;

import lombok.*;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Getter
@IdClass(FollowId.class)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
public class Follow extends ArticleBaseTime implements Serializable {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "follower_user_id")
    private User followerUserId;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "following_user_id")
    private User followingUserId;

    public static Follow follow(User followerUser, User followingUser) {
        return Follow.builder()
                .followerUserId(followerUser)
                .followingUserId(followingUser)
                .build();
    }
}
