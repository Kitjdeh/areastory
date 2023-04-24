package com.areastory.user.db.repository.support;

import com.areastory.user.db.entity.QFollow;
import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;
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

import static com.areastory.user.db.entity.QFollow.*;


@Repository
@RequiredArgsConstructor
public class FollowRepositorySupportImpl implements FollowRepositorySupport {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<FollowerResp> findFollowerResps(Long userId, PageRequest pageRequest, String search) {

        QFollow followSub = new QFollow("followSub");
        BooleanExpression isFollowing = followSub.followerUserId.userId.eq(userId).and(followSub.followingUserId.eq(follow.followerUserId));

        List<Tuple> tuples = queryFactory
                .select(Projections.constructor(FollowerResp.class),
                        follow.followerUserId.userId,
                        follow.followerUserId.nickname,
                        follow.followerUserId.profile,
                        ExpressionUtils.as(
                                JPAExpressions.selectOne()
                                        .from(followSub)
                                        .where(isFollowing)
                                        .exists(),
                                "check"
                        ))
                .from(follow)
                .where(follow.followingUserId.userId.eq(userId), follow.followerUserId.nickname.like(search))
                .orderBy(follow.followerUserId.nickname.asc())
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
                        follow.followingUserId.userId,
                        follow.followingUserId.nickname,
                        follow.followingUserId.profile)
                .from(follow)
                .where(follow.followerUserId.userId.eq(userId), follow.followingUserId.nickname.like(search))
                .orderBy(follow.followingUserId.nickname.asc())
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
