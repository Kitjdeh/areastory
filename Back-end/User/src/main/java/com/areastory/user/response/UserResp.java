package com.areastory.user.response;

import com.areastory.user.db.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResp {

    private Long userId;
    private String nickname;
    private String profile;
    private Long followCount;
    private Long followingCount;
    private Boolean isNew;

    public static UserResp fromEntity(User user) {
        return UserResp.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .profile(user.getProfile())
                .followCount(user.getFollowCount())
                .followingCount(user.getFollowingCount())
                .build();
    }

    public static UserResp fromEntity(User user, Boolean isNew) {
        return UserResp.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .profile(user.getProfile())
                .followCount(user.getFollowCount())
                .followingCount(user.getFollowingCount())
                .isNew(isNew)
                .build();
    }

    public static UserResp fromEntity(Boolean isNew) {
        return UserResp.builder()
                .isNew(isNew)
                .build();
    }
}
