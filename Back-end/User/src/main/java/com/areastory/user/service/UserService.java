package com.areastory.user.service;

import com.areastory.user.dto.request.UserReq;
import com.areastory.user.dto.response.ArticleResp;
import com.areastory.user.dto.response.UserDetailResp;
import com.areastory.user.dto.response.UserResp;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

public interface UserService {

    void validateUser(Long userId);

    Boolean findUser(Long userId);

    UserResp login(Long providerId);

    void logout(Long userId);

    void signUp(UserReq userReq, MultipartFile profile) throws IOException, NoSuchAlgorithmException;

    UserResp getMyDetail(Long userId);

    void updateUserNickName(Long userId, String nickname);

    void deleteUser(Long userId);

    Page<ArticleResp> getArticleList(Long userId, int page);

    void updateProfile(Long userId, MultipartFile profile) throws IOException;

    UserDetailResp getUserDetail(Long userId, Long myId);
}
