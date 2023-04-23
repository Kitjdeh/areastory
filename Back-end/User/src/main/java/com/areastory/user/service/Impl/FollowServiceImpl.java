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

    public String searchCondition(String search) {
        if (search == null || search.isEmpty()) {
            return "%";
        } else {
            return "%" + search + "%";
        }
    }

    public List<FollowerResp> findFollowers(Long userId, int page, String search) {
        PageRequest pageRequest = PageRequest.of(page, 20);
//        List<Follow> followList = followRepository.findByFollowingUserId_UserId(userId, pageRequest);
//        List<User> userList = followList.stream()
//                .map(Follow::getFollowerUserId).collect(Collectors.toList());
//        List<Long> userIdList = userList.stream()
//                .map(User::getUserId)
//                .collect(Collectors.toList());

        return followRepository.findFollwerResps(userId, pageRequest, searchCondition(search));
    }

    @Override
    public List<FollowingResp> findFollowing(Long userId, int page, int type) {
        PageRequest pageRequest = null;
        if (type == 1) {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "followingUserId.nickname");
        } else if (type == 2) {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "createdAt");
        } else {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.DESC, "createdAt");
        }
        return followRepository.findByFollowerUserId_UserId(userId, pageRequest)
                .stream().map(m -> FollowingResp.fromEntity(m)).collect(
                        Collectors.toList());
    }

    @Override
    public List<FollowingResp> findFollowingBySearch(Long userId, int page, String search) {
        PageRequest pageRequest = PageRequest.of(page, 20);
        return followRepository.findFollowingResp(userId, pageRequest, searchCondition(search));
    }

    @Override
    public Boolean addFollower(Long userId, Long followingId) {

        if (!followRepository.existsByFollowerUserId_UserIdAndFollowingUserId_UserId(userId, followingId)) {
            User user = userRepository.findById(userId).orElse(null);
            User followingUser = userRepository.findById(followingId).orElse(null);

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

        if (followRepository.existsByFollowerUserId_UserIdAndFollowingUserId_UserId(userId, followingId)) {
            followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(userId, followingId);
            userRepository.updateFollowingDisCount(userId);
            userRepository.updateFollowDisCount(followingId);
            return true;
        } else {
            return false;
        }
    }

    @Override
    public Boolean deleteFollower(Long userId, Long followerId) {

        if (followRepository.existsByFollowerUserId_UserIdAndFollowingUserId_UserId(followerId, userId)) {
            followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(followerId, userId);
            userRepository.updateFollowDisCount(userId);
            userRepository.updateFollowingDisCount(followerId);
            return true;
        } else {
            return false;
        }
    }
}
