package com.areastory.user.db.entity;

import lombok.*;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Builder
public class FollowId implements Serializable {

    private Long followerUser;
    private Long followingUser;

}
