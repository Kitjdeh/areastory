package com.areastory.user.db.repository.support;

import com.areastory.user.dto.request.UserInfoReq;
import com.areastory.user.dto.response.UserDetailResp;

public interface UserRepositorySupport {

    UserDetailResp findUserDetailResp(Long userId, Long myId);

    void updateUserInfo(Long userId, UserInfoReq userInfoReq, String saveUploadFile);
}
