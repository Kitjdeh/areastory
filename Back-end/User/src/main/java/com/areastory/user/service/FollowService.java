package com.areastory.user.service;

import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;

import java.util.List;

public interface FollowService {
    List<FollowerResp> findFollowers(Long userId, int page);

    List<FollowingResp> findFollowing(Long userId, int page);

    Boolean addFollower(Long userId, Long followingId);

    Boolean deleteFollowing(Long userId, Long followingId);

    Boolean deleteFollower(Long userId, Long followerId);
}
