package com.areastory.user.db.repository.support;

import com.areastory.user.db.entity.QFollow;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingResp;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.stream.Collectors;

import static com.areastory.user.db.entity.QFollow.follow;


@Repository
@RequiredArgsConstructor
public class FollowRepositorySupportImpl implements FollowRepositorySupport {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<FollowerResp> findFollowerResp(Long userId, PageRequest pageRequest, String search) {

        QFollow followSub = new QFollow("followSub");
        BooleanExpression isFollowing = followSub.followerUser.userId.eq(userId).and(followSub.followingUser.eq(follow.followerUser));

        List<Tuple> tuples = queryFactory
                .select(Projections.constructor(FollowerResp.class),
                        follow.followerUser.userId,
                        follow.followerUser.nickname,
                        follow.followerUser.profile,
                        ExpressionUtils.as(
                                JPAExpressions.selectOne()
                                        .from(followSub)
                                        .where(isFollowing)
                                        .exists(),
                                "check"
                        ))
                .from(follow)
                .where(follow.followingUser.userId.eq(userId), follow.followerUser.nickname.like(search))
                .orderBy(follow.createdAt.desc())
                .offset(pageRequest.getOffset())
                .limit(pageRequest.getPageSize())
                .fetch();

        return tuples.stream()
                .map(tuple -> new FollowerResp(tuple.get(1, Long.class),
                        tuple.get(2, String.class),
                        tuple.get(3, String.class),
                        tuple.get(4, Boolean.class)))
                .collect(Collectors.toList());
    }

    @Override
    public List<FollowingResp> findFollowingResp(Long userId, PageRequest pageRequest, String search) {
        List<Tuple> tuples = queryFactory
                .select(Projections.constructor(FollowingResp.class),
                        follow.followingUser.userId,
                        follow.followingUser.nickname,
                        follow.followingUser.profile)
                .from(follow)
                .where(follow.followerUser.userId.eq(userId), follow.followingUser.nickname.like(search))
                .orderBy(follow.createdAt.desc())
                .offset(pageRequest.getOffset())
                .limit(pageRequest.getPageSize())
                .fetch();

        return tuples.stream()
                .map(tuple -> new FollowingResp(tuple.get(1, Long.class),
                        tuple.get(2, String.class),
                        tuple.get(3, String.class)))
                .collect(Collectors.toList());
    }

}
