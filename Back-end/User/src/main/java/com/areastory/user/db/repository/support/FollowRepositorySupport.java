package com.areastory.user.db.repository.support;

import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingResp;
import org.springframework.data.domain.PageRequest;

import java.util.List;

public interface FollowRepositorySupport {

//    List<FollowerResp> findFollowerResp(Long userId, PageRequest pageRequest, String search);
    List<FollowerResp> findFollowerResp(Long userId, String search);

    List<FollowingResp> findFollowing(Long userId, int type);


    List<FollowingResp> findFollowingResp(Long userId, String search);
//    List<FollowingResp> findFollowingResp(Long userId, PageRequest pageRequest, String search);
}
