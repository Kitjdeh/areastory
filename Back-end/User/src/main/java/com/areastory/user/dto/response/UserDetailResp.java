package com.areastory.user.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDetailResp {

    private Long userId;
    private String nickname;
    private String profile;
    private Long articleCount;
    private Long followCount;
    private Long followingCount;
    private Boolean followYn;


}
