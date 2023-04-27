package com.areastory.article.api.service;

import com.areastory.article.dto.common.UserKafkaDto;

public interface UserService {
    void addUser(UserKafkaDto userKafkaDto);

    void updateUser(UserKafkaDto userKafkaDto);

    void deleteUser(UserKafkaDto userKafkaDto);
}
