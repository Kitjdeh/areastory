package com.areastory.user.dto.request;

import com.areastory.user.db.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserReq {
    private String nickname; // 닉네임
    private String provider; // 소셜 로그인 종류
    private Long providerId; // 소셜 로그인 아이디
    private String registrationToken;

    public static User toEntity(UserReq userReq, String profile, String hashKey, String registrationToken) {
        return User.builder()
                .nickname(userReq.getNickname())
                .profile(profile)
                .provider(userReq.getProvider())
                .providerId(userReq.getProviderId())
                .followCount(0L)
                .followingCount(0L)
                .isValid(false)
                .hashKey(hashKey)
                .registrationToken(registrationToken)
                .build();
    }
}
