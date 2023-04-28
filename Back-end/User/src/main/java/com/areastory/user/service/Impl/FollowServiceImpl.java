package com.areastory.user.service.Impl;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.FollowId;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.FollowRepository;
import com.areastory.user.db.repository.UserRepository;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingResp;
import com.areastory.user.kafka.KafkaProperties;
import com.areastory.user.kafka.NotificationProducer;
import com.areastory.user.kafka.UserProducer;
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
@Slf4j
public class FollowServiceImpl implements FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;
    private final UserProducer userProducer;
    private final NotificationProducer notificationProducer;

    public String searchCondition(String search) {
        if (search == null || search.isEmpty()) {
            return "%";
        } else {
            return "%" + search + "%";
        }
    }

    public List<FollowerResp> findFollowers(Long userId, int page, String search) {
        PageRequest pageRequest = PageRequest.of(page, 20);
        return followRepository.findFollowerResp(userId, pageRequest, searchCondition(search));
    }

    @Override
    public List<FollowingResp> findFollowing(Long userId, int page, int type) {
        PageRequest pageRequest;
        if (type == 1) {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "followingUser.nickname");
        } else if (type == 2) {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.ASC, "createdAt");
        } else {
            pageRequest = PageRequest.of(page, 20, Sort.Direction.DESC, "createdAt");
        }
        return followRepository.findByFollowerUser_UserId(userId, pageRequest)
                .stream().map(FollowingResp::fromEntity).collect(
                        Collectors.toList());
    }

    @Override
    public List<FollowingResp> findFollowingBySearch(Long userId, int page, String search) {
        PageRequest pageRequest = PageRequest.of(page, 20);
        return followRepository.findFollowingResp(userId, pageRequest, searchCondition(search));
    }

    @Override
    @Transactional
    public Boolean addFollower(Long userId, Long followingId) {
        FollowId followId = new FollowId(userId, followingId);
        if (followRepository.existsById(followId))
            return false;
        User user = userRepository.findById(userId).orElseThrow();
        User followingUser = userRepository.findById(followingId).orElseThrow();

        Follow follow = followRepository.save(Follow.follow(user, followingUser));

        user.addFollowing();
        followingUser.addFollow();

        notificationProducer.send(follow);
        userProducer.send(user, KafkaProperties.UPDATE);
        userProducer.send(followingUser, KafkaProperties.UPDATE);
        return true;
    }

    @Override
    @Transactional
    public Boolean deleteFollowing(Long userId, Long followingId) {
        FollowId followId = new FollowId(userId, followingId);
        if (!followRepository.existsById(followId)) {
            return false;
        }
        followRepository.deleteById(followId);
        User user = userRepository.findById(userId).orElseThrow();
        User followingUser = userRepository.findById(followingId).orElseThrow();

        user.deleteFollowing();
        followingUser.deleteFollow();

        userProducer.send(user, KafkaProperties.UPDATE);
        userProducer.send(followingUser, KafkaProperties.UPDATE);
        return true;
    }

    @Override
    @Transactional
    public Boolean deleteFollower(Long userId, Long followerId) {
        FollowId followId = new FollowId(followerId, userId);
        if (!followRepository.existsById(followId)) {
            return false;
        }
        followRepository.deleteById(followId);
        User user = userRepository.findById(userId).orElseThrow();
        User followerUser = userRepository.findById(followerId).orElseThrow();
        user.deleteFollow();
        followerUser.deleteFollowing();
        userProducer.send(user, KafkaProperties.UPDATE);
        userProducer.send(followerUser, KafkaProperties.UPDATE);
        return true;
    }
}
