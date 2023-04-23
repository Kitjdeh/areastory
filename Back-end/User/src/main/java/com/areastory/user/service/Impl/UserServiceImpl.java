package com.areastory.user.service.Impl;

import com.areastory.user.util.S3Util;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.ArticleRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.request.UserReq;
import com.areastory.user.response.ArticleResp;
import com.areastory.user.response.UserResp;
import com.areastory.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ArticleRepository articleRepository;
    private final S3Util s3Config;

    @Override
    public Boolean findUser(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return false;
        }
        return true;
    }

    @Override
    public UserResp login(Long providerId) {
        User findUser = userRepository.findByProviderId(providerId).orElse(null);
        if (findUser == null) {
            return UserResp.fromEntity(false);
        }
        return UserResp.fromEntity(findUser, true);
    }
    @Override
    public void signUp(UserReq userReq, MultipartFile profile) throws IOException {
        if (profile == null || profile.isEmpty()) {
            userRepository.save(UserReq.toEntity(userReq, null));
        } else {
            userRepository.save(UserReq.toEntity(userReq, s3Config.saveUploadFile(profile)));
        }
    }

    @Override
    public UserResp getUserDetail(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        return UserResp.fromEntity(user);
    }

    @Override
    public void updateUserNickName(Long userId, String nickname) {
        userRepository.updateNickname(userId, nickname);
    }

    @Override
    public void updateProfile(Long userId, MultipartFile profile) throws IOException {
        User user = userRepository.findById(userId).orElse(null);
        if (user.getProfile() != null) {
            s3Config.deleteFile(user.getProfile().substring(55));
        }

        if (profile == null || profile.isEmpty()) {
            userRepository.updateProfile(userId, null);
        } else {
            userRepository.updateProfile(userId, s3Config.saveUploadFile(profile));
        }
    }

    @Override
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    @Override
    public Page<ArticleResp> getArticleList(Long userId, int page) {
        Pageable pageable = PageRequest.of(page, 20, Sort.Direction.DESC, "createdAt");
        User user = userRepository.findById(userId).orElse(null);
        return articleRepository.findAllByUserIdOrderByCreatedAtDesc(user, pageable)
                .map(ArticleResp::fromEntity);
    }


}
