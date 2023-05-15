package com.areastory.user.db.repository.support;

import com.areastory.user.dto.request.UserInfoReq;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.UserDetailResp;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface UserRepositorySupport {

    UserDetailResp findUserDetailResp(Long userId, Long myId);

    void updateUserInfo(Long userId, UserInfoReq userInfoReq, String saveUploadFile);

    Page<FollowerResp> getUserBySearch(Long userId, Pageable page, String search);
}
