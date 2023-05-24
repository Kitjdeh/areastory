package com.areastory.user.service;

import com.areastory.user.dto.response.FollowerPageResp;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingPageResp;
import com.areastory.user.dto.response.FollowingResp;

import java.util.List;

public interface FollowService {
//    List<FollowerResp> findFollowers(Long userId, String search);
    FollowerPageResp findFollowers(Long userId, int page, int type);
    List<FollowerResp> findFollowersList(Long userId, int type);

//    List<FollowingResp> findFollowing(Long userId, int type);
    FollowingPageResp findFollowing(Long userId, int page, int type);
    List<FollowingResp> findFollowingList(Long userId);

    List<FollowingResp> findFollowingBySearch(Long userId, String search);
//    List<FollowingResp> findFollowingBySearch(Long userId, int page, String search);

    Boolean addFollower(Long userId, Long followingId);

    Boolean deleteFollowing(Long userId, Long followingId);

    Boolean deleteFollower(Long userId, Long followerId);

}
