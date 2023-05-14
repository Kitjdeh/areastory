package com.areastory.user.db.repository.support;

import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingResp;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface FollowRepositorySupport {

    Page<FollowerResp> findFollowers(Long userId, Pageable pageable, int type);
//    List<FollowerResp> findFollowerResp(Long userId, String search);
    List<FollowerResp> findFollowersList(Long userId, int type);

    Page<FollowingResp> findFollowing(Long userId, Pageable pageable, int type);


    List<FollowingResp> findFollowingResp(Long userId, String search);

    List<FollowingResp> findFollowingList(Long userId);


//    List<FollowingResp> findFollowingResp(Long userId, PageRequest pageRequest, String search);
}
