package com.areastory.user.db.repository.support;

public interface UserRepositorySupport {

    void updateFollowingAddCount(Long userId);
    void updateFollowAddCount(Long followingId);
    void updateFollowingDisCount(Long userId);
    void updateFollowDisCount(Long followingId);

    void updateNickname(Long userId, String nickname);
    void updateProfile(Long userId, String profile);
}
