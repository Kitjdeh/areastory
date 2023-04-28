package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.ArticleRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.request.UserReq;
import com.areastory.user.dto.response.ArticleResp;
import com.areastory.user.dto.response.UserResp;
import com.areastory.user.kafka.KafkaProperties;
import com.areastory.user.kafka.UserProducer;
import com.areastory.user.service.UserService;
import com.areastory.user.sse.Emitters;
import com.areastory.user.util.S3Util;
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
@Slf4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final ArticleRepository articleRepository;
    private final S3Util s3Util;
    private final UserProducer userProducer;
    private final Emitters emitters;

    @Override
    @Transactional
    public void validateUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        user.setValid();
        emitters.getValid(userId);
    }

    @Override
    public Boolean findUser(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
//        log.info("User found: " + user);
        return user != null;
    }

    @Override
    public UserResp login(Long providerId) {
        User findUser = userRepository.findByProviderId(providerId).orElse(null);
        if (findUser == null) {
            return UserResp.fromEntity(false);
        }
        emitters.add(findUser.getUserId());
        return UserResp.fromEntity(findUser, true);
    }

    @Override
    public void logout(Long userId) {
        emitters.remove(userId);
    }

    @Override
    @Transactional
    public void signUp(UserReq userReq, MultipartFile profile) throws IOException {
        User user = userRepository.save(UserReq.toEntity(userReq, s3Util.saveUploadFile(profile)));
        userProducer.send(user, KafkaProperties.INSERT);
        emitters.addWaiting(user.getUserId());
    }

    @Override
    public UserResp getUserDetail(Long userId) {
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
    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        userRepository.delete(user);
        userProducer.send(user, KafkaProperties.DELETE);
    }

    @Override
    public Page<ArticleResp> getArticleList(Long userId, int page) {
        Pageable pageable = PageRequest.of(page, 20, Sort.Direction.DESC, "createdAt");
        User user = userRepository.findById(userId).orElseThrow();
        return articleRepository.findByUser(user, pageable)
                .map(ArticleResp::fromEntity);
    }


}
