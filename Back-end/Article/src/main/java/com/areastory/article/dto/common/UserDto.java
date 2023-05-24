package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class UserDto {
    private Long userId;
    private String nickname;
    private String profile;
    private Boolean followYn;

    public UserDto(Long userId, String nickname, String profile, Boolean followYn) {
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.followYn = followYn;
    }
}
