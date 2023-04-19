package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.User;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Arrays;
import java.util.List;

public interface FollowRepository extends JpaRepository<Follow, Long> {
    List<Follow> findByFollowerUserId_UserId(Long userId, PageRequest pageRequest);

    List<Follow> findByFollowingUserId_UserId(Long userId, PageRequest pageRequest);

    void deleteByFollowerUserIdAndFollowingUserId(User user, User followingUser);

    boolean existsByFollowerUserIdAndFollowingUserId(User followerUserId, User followingUserId);
}
