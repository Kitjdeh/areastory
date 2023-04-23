package com.areastory.user.response;

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
//    private boolean check;

    public static FollowerResp fromEntity(Follow follow) {
        return FollowerResp.builder()
                .userId(follow.getFollowerUserId().getUserId())
                .nickname(follow.getFollowerUserId().getNickname())
                .profile(follow.getFollowerUserId().getProfile())
                .build();
    }

}
