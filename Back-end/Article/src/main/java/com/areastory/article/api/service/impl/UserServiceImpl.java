package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.UserService;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.UserKafkaDto;
import com.areastory.article.exception.CustomException;
import com.areastory.article.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public void addUser(UserKafkaDto userKafkaDto) {
        userRepository.save(User.builder()
                .userId(userKafkaDto.getUserId())
                .nickname(userKafkaDto.getNickname())
                .profile(userKafkaDto.getProfile())
                .provider(userKafkaDto.getProvider())
                .providerId(userKafkaDto.getProviderId())
                .build());
    }

    @Override
    public void updateUser(UserKafkaDto userKafkaDto) {
        User user = userRepository.findById(userKafkaDto.getUserId()).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));
        user.setNickname(userKafkaDto.getNickname());
        user.setProfile(userKafkaDto.getProfile());
    }

    @Override
    public void deleteUser(UserKafkaDto userKafkaDto) {
        userRepository.deleteById(userKafkaDto.getUserId());
    }

}
