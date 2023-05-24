package com.areastory.user.dto.response;


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
                .userId(follow.getFollowingUser().getUserId())
                .nickname(follow.getFollowingUser().getNickname())
                .profile(follow.getFollowingUser().getProfile())
                .build();
    }
}
