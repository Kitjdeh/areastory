package com.areastory.user.response;


import com.areastory.user.db.entity.Follow;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FollowingResp {

    private Long userId;
    private String nickname;
    private String profile;

    public static FollowingResp fromEntity(Follow follow) {
        return FollowingResp.builder()
                .userId(follow.getFollowingUserId().getUserId())
                .nickname(follow.getFollowingUserId().getNickname())
                .profile(follow.getFollowingUserId().getProfile())
                .build();
    }
}
