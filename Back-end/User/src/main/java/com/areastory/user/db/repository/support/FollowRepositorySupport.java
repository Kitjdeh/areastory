package com.areastory.user.db.repository.support;

import com.areastory.user.db.entity.User;
import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;
import org.springframework.data.domain.PageRequest;

import java.util.List;

public interface FollowRepositorySupport {

    List<FollowerResp> findFollwerResps(Long userId, PageRequest pageRequest, String search);

    List<FollowingResp> findFollowingResp(Long userId, PageRequest pageRequest, String search);
}
