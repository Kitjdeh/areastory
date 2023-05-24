package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.FollowId;
import com.areastory.user.db.repository.support.FollowRepositorySupport;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FollowRepository extends JpaRepository<Follow, FollowId>, FollowRepositorySupport {
    List<Follow> findByFollowerUser_UserId(Long userId, PageRequest pageRequest);


    void deleteByFollowerUser_UserIdAndFollowingUser_UserId(Long user, Long followingUserId);

}
