package com.areastory.user.dto.response;

import com.areastory.user.db.entity.Follow;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FollowerResp {

    private Long userId;
    private String nickname;
    private String profile;
    private Boolean check;

    public static FollowerResp fromEntity(Follow follow) {
        return FollowerResp.builder()
                .userId(follow.getFollowerUser().getUserId())
                .nickname(follow.getFollowerUser().getNickname())
                .profile(follow.getFollowerUser().getProfile())
                .build();
    }

    public static FollowerResp fromEntityWithCheck(Follow follow, Boolean check) {
        return FollowerResp.builder()
                .userId(follow.getFollowerUser().getUserId())
                .nickname(follow.getFollowerUser().getNickname())
                .profile(follow.getFollowerUser().getProfile())
                .check(check)
                .build();
    }

    public static FollowerResp followerResp (Long userId, String nickname, String profile, Boolean check) {
        return FollowerResp.builder()
                .userId(userId)
                .nickname(nickname)
                .profile(profile)
                .check(check)
                .build();
    }
}
