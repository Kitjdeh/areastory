package com.areastory.user.db.entity;

import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Getter
@IdClass(FollowId.class)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
@Table(name = "follow", indexes = {
        @Index(name = "idx_created_at_follower", columnList = "follower_user_id,created_at"),
        @Index(name = "idx_created_at_following", columnList = "following_user_id, created_at")})
public class Follow extends BaseTime implements Serializable {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "follower_user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User followerUser;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "following_user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User followingUser;

    public static Follow follow(User followerUser, User followingUser) {
        return Follow.builder()
                .followerUser(followerUser)
                .followingUser(followingUser)
                .build();
    }
}
