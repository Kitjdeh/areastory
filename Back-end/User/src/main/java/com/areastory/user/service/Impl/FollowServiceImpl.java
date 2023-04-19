package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.FollowRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;
import com.areastory.user.service.FollowService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class FollowServiceImpl implements FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;

    public List<FollowerResp> findFollowers(Long userId, int page) {
        PageRequest pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "followerUserId.nickname");
        return followRepository.findByFollowingUserId_UserId(userId, pageRequest)
                .stream().map(m -> FollowerResp.fromEntity(m)).collect(
                        Collectors.toList());
    }

    @Override
    public List<FollowingResp> findFollowing(Long userId, int page) {
        PageRequest pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "followingUserId.nickname");
        return followRepository.findByFollowerUserId_UserId(userId, pageRequest)
                .stream().map(m -> FollowingResp.fromEntity(m)).collect(
                        Collectors.toList());
    }

    @Override
    public Boolean addFollower(Long userId, Long followingId) {
        User user = userRepository.findById(userId).orElse(null);
        User followingUser = userRepository.findById(followingId).orElse(null);

        if (!followRepository.existsByFollowerUserIdAndFollowingUserId(user, followingUser)) {
            followRepository.save(Follow.follow(user, followingUser));
            userRepository.updateFollowingAddCount(userId);
            userRepository.updateFollowAddCount(followingId);
            return true;
        } else {
            return false;
        }
    }

    @Override
    public Boolean deleteFollowing(Long userId, Long followingId) {
        User user = userRepository.findById(userId).orElse(null);
        User followingUser = userRepository.findById(followingId).orElse(null);

        if (followRepository.existsByFollowerUserIdAndFollowingUserId(user, followingUser)) {
            followRepository.deleteByFollowerUserIdAndFollowingUserId(user, followingUser);
            userRepository.updateFollowingDisCount(userId);
            userRepository.updateFollowDisCount(followingId);
            return true;
        } else {
            return false;
        }
    }

    @Override
    public Boolean deleteFollower(Long userId, Long followerId) {
        User user = userRepository.findById(userId).orElse(null);
        User followerUser = userRepository.findById(followerId).orElse(null);

        if (followRepository.existsByFollowerUserIdAndFollowingUserId(followerUser, user)) {
            followRepository.deleteByFollowerUserIdAndFollowingUserId(followerUser, user);
            userRepository.updateFollowDisCount(userId);
            userRepository.updateFollowingDisCount(followerId);
            return true;
        } else {
            return false;
        }
    }
}
