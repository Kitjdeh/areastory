package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.ArticleRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.common.ArticleDto;
import com.areastory.user.dto.request.UserInfoReq;
import com.areastory.user.dto.request.UserReq;
import com.areastory.user.dto.response.ArticleResp;
import com.areastory.user.dto.response.UserDetailResp;
import com.areastory.user.dto.response.UserResp;
import com.areastory.user.dto.response.UserSignUpResp;
import com.areastory.user.kafka.KafkaProperties;
import com.areastory.user.kafka.UserProducer;
import com.areastory.user.service.UserService;
import com.areastory.user.util.S3Util;
import com.areastory.user.util.Sha256Util;
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
import java.security.NoSuchAlgorithmException;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final ArticleRepository articleRepository;
    private final S3Util s3Util;
    private final UserProducer userProducer;
    private final Sha256Util sha256Util;

    @Override
    @Transactional
    public void validateUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setValid();
//        emitters.getValid(userId);
    }

    @Override
    public Boolean findUser(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
//        log.info("User found: " + user);
        return user != null;
    }

    @Override
    @Transactional
    public UserResp login(Long providerId, String registrationToken) {
        User findUser = userRepository.findByProviderId(providerId).orElse(null);
        if (findUser == null) {
            return UserResp.fromEntity(false);
        }
        findUser.setRegistrationToken(registrationToken);
        return UserResp.fromEntity(findUser, true);
    }

    @Override
    public void logout(Long userId) {
    }

    @Override
    @Transactional
    public UserSignUpResp signUp(UserReq userReq, MultipartFile profile) throws IOException, NoSuchAlgorithmException {
        User user = userRepository.save(UserReq.toEntity(userReq, s3Util.saveUploadFile(profile), sha256Util.sha256(userReq.getProviderId()), userReq.getRegistrationToken()));
        userProducer.send(user, KafkaProperties.INSERT);
        return UserSignUpResp.fromEntity(user);
    }

    @Override
    @Transactional
    public void updateUserInfo(Long userId, UserInfoReq userInfoReq, MultipartFile profile) throws IOException {
        User user = userRepository.findById(userId).orElseThrow();
        s3Util.deleteFile(user.getProfile());
        user.setNickname(userInfoReq.getNickname());
        String changedProfile = s3Util.saveUploadFile(profile);
        user.setProfile(changedProfile);
        userProducer.send(user, KafkaProperties.UPDATE);
    }

    @Override
    public UserResp getMyDetail(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        return UserResp.fromEntity(user);
    }

    @Override
    @Transactional
    public void updateUserNickName(Long userId, String nickname) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setNickname(nickname);
        userProducer.send(user, KafkaProperties.UPDATE);
    }

    @Override
    @Transactional
    public void updateProfile(Long userId, MultipartFile profile) throws IOException {
        User user = userRepository.findById(userId).orElseThrow();
        s3Util.deleteFile(user.getProfile());
        String changedProfile = s3Util.saveUploadFile(profile);
        user.setProfile(changedProfile);
        userProducer.send(user, KafkaProperties.UPDATE);
    }

    @Override
    public UserDetailResp getUserDetail(Long userId, Long myId) {
        return userRepository.findUserDetailResp(userId, myId);
    }

    @Override
    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        s3Util.deleteFile(user.getProfile());
        userRepository.delete(user);
        userProducer.send(user, KafkaProperties.DELETE);
    }

//    @Override
//    public List<ArticleResp> getArticleList(Long userId) {
//        return articleRepository.getArticleList(userId);
//    }
//
//    @Override
//    public List<ArticleResp> getOtherUserArticleList(Long userId) {
//        return articleRepository.getOtherUserArticleList(userId);
//    }


    @Override
    public ArticleResp getArticleList(Long userId, int page) {
        Pageable pageable = PageRequest.of(page, 20, Sort.Direction.DESC, "createdAt");
        User user = userRepository.findById(userId).orElseThrow();
        Page<ArticleDto> articleDtos = articleRepository.findByUser(user, pageable)
                .map(ArticleDto::fromEntity);
        return ArticleResp.fromArticleDto(articleDtos);
    }

//    @Override
//    public ArticleResp getOtherUserArticleList(Long userId, int page) {
//        Pageable pageable = PageRequest.of(page, 20, Sort.Direction.DESC, "createAt");
//        Page<ArticleDto> articleDtos = articleRepository.getOtherUserArticleList(userId, pageable);
//        return ArticleResp.fromArticleDto(articleDtos);
//    }

}
