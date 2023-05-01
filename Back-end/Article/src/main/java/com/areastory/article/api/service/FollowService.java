package com.areastory.article.api.service;

import com.areastory.article.dto.common.FollowKafkaDto;

public interface FollowService {
    void addFollow(FollowKafkaDto followKafkaDto);

    void deleteFollow(FollowKafkaDto followKafkaDto);
}
