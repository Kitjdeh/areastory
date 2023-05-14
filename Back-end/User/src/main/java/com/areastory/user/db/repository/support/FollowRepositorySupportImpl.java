package com.areastory.user.db.repository.support;

import com.areastory.user.db.entity.QFollow;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.FollowingResp;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.areastory.user.db.entity.QFollow.follow;


@Repository
@RequiredArgsConstructor
public class FollowRepositorySupportImpl implements FollowRepositorySupport {

    private final JPAQueryFactory queryFactory;


    @Override
    public Page<FollowerResp> findFollowers(Long userId, Pageable pageable, int type) {

        QFollow followSub = new QFollow("followSub");
        BooleanExpression isFollowing = followSub.followerUser.userId.eq(userId).and(followSub.followingUser.eq(follow.followerUser));

        List<FollowerResp> followerRespList = queryFactory
                .select(Projections.constructor(FollowerResp.class,
                        follow.followerUser.userId,
                        follow.followerUser.nickname,
                        follow.followerUser.profile,
                        ExpressionUtils.as(
                                JPAExpressions.selectOne()
                                        .from(followSub)
                                        .where(isFollowing)
                                        .exists(),
                                "check"
                        )))
                .from(follow)
                .where(follow.followingUser.userId.eq(userId))
                .orderBy(findFollowerOrderType(type))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> followerSize = queryFactory
                .select(follow.count())
                .from(follow)
                .where(follow.followingUser.userId.eq(userId));

        return PageableExecutionUtils.getPage(followerRespList, pageable, followerSize::fetchOne);

    }

    @Override
    public List<FollowerResp> findFollowersList(Long userId, int type) {

        QFollow followSub = new QFollow("followSub");
        BooleanExpression isFollowing = followSub.followerUser.userId.eq(userId).and(followSub.followingUser.eq(follow.followerUser));

        return queryFactory
                .select(Projections.constructor(FollowerResp.class,
                        follow.followerUser.userId,
                        follow.followerUser.nickname,
                        follow.followerUser.profile,
                        ExpressionUtils.as(
                                JPAExpressions.selectOne()
                                        .from(followSub)
                                        .where(isFollowing)
                                        .exists(),
                                "check")))
                .from(follow)
                .where(follow.followingUser.userId.eq(userId))
                .orderBy(findFollowerOrderType(type))
                .fetch();
    }

    @Override
    public Page<FollowingResp> findFollowing(Long userId, Pageable pageable, int type) {
        List<FollowingResp> followingRespList = queryFactory
                .select(Projections.constructor(FollowingResp.class,
                        follow.followingUser.userId,
                        follow.followingUser.nickname,
                        follow.followingUser.profile))
                .from(follow)
                .where(follow.followerUser.userId.eq(userId))
                .orderBy(findFollowingOrderType(type))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> followingSize = queryFactory
                .select(follow.count())
                .from(follow)
                .where(follow.followerUser.userId.eq(userId));

        return PageableExecutionUtils.getPage(followingRespList, pageable, followingSize::fetchOne);
    }

//    @Override
//    public List<FollowerResp> findFollowerResp(Long userId, PageRequest pageRequest, String search) {
//
//        QFollow followSub = new QFollow("followSub");
//        BooleanExpression isFollowing = followSub.followerUser.userId.eq(userId).and(followSub.followingUser.eq(follow.followerUser));
//
//        List<Tuple> tuples = queryFactory
//                .select(Projections.constructor(FollowerResp.class),
//                        follow.followerUser.userId,
//                        follow.followerUser.nickname,
//                        follow.followerUser.profile,
//                        ExpressionUtils.as(
//                                JPAExpressions.selectOne()
//                                        .from(followSub)
//                                        .where(isFollowing)
//                                        .exists(),
//                                "check"
//                        ))
//                .from(follow)
//                .where(follow.followingUser.userId.eq(userId), follow.followerUser.nickname.like(search))
//                .orderBy(follow.createdAt.desc())
//                .offset(pageRequest.getOffset())
//                .limit(pageRequest.getPageSize())
//                .fetch();
//
//        return tuples.stream()
//                .map(tuple -> new FollowerResp(tuple.get(1, Long.class),
//                        tuple.get(2, String.class),
//                        tuple.get(3, String.class),
//                        tuple.get(4, Boolean.class)))
//                .collect(Collectors.toList());
//    }

//    @Override
//    public List<FollowerResp> findFollowerResp(Long userId, String search) {
//
//        QFollow followSub = new QFollow("followSub");
//        BooleanExpression isFollowing = followSub.followerUser.userId.eq(userId).and(followSub.followingUser.eq(follow.followerUser));
//
//        List<Tuple> tuples = queryFactory
//                .select(Projections.constructor(FollowerResp.class),
//                        follow.followerUser.userId,
//                        follow.followerUser.nickname,
//                        follow.followerUser.profile,
//                        ExpressionUtils.as(
//                                JPAExpressions.selectOne()
//                                        .from(followSub)
//                                        .where(isFollowing)
//                                        .exists(),
//                                "check"
//                        ))
//                .from(follow)
//                .where(follow.followingUser.userId.eq(userId), follow.followerUser.nickname.like(search))
//                .orderBy(follow.createdAt.desc())
//                .fetch();
//
//        return tuples.stream()
//                .map(tuple -> new FollowerResp(tuple.get(1, Long.class),
//                        tuple.get(2, String.class),
//                        tuple.get(3, String.class),
//                        tuple.get(4, Boolean.class)))
//                .collect(Collectors.toList());
//    }


    @Override
    public List<FollowingResp> findFollowingResp(Long userId, String search) {
        return queryFactory
                .select(Projections.constructor(FollowingResp.class,
                        follow.followingUser.userId,
                        follow.followingUser.nickname,
                        follow.followingUser.profile))
                .from(follow)
                .where(follow.followerUser.userId.eq(userId), follow.followingUser.nickname.like(search))
                .orderBy(follow.createdAt.desc())
                .fetch();
    }

    @Override
    public List<FollowingResp> findFollowingList(Long userId) {
        return queryFactory
                .select(Projections.constructor(FollowingResp.class,
                        follow.followingUser.userId,
                        follow.followingUser.nickname,
                        follow.followingUser.profile))
                .from(follow)
                .where(follow.followerUser.userId.eq(userId))
                .fetch();
    }

//    @Override
//    public List<FollowingResp> findFollowingResp(Long userId, PageRequest pageRequest, String search) {
//        List<Tuple> tuples = queryFactory
//                .select(Projections.constructor(FollowingResp.class),
//                        follow.followingUser.userId,
//                        follow.followingUser.nickname,
//                        follow.followingUser.profile)
//                .from(follow)
//                .where(follow.followerUser.userId.eq(userId), follow.followingUser.nickname.like(search))
//                .orderBy(follow.createdAt.desc())
//                .offset(pageRequest.getOffset())
//                .limit(pageRequest.getPageSize())
//                .fetch();
//
//        return tuples.stream()
//                .map(tuple -> new FollowingResp(tuple.get(1, Long.class),
//                        tuple.get(2, String.class),
//                        tuple.get(3, String.class)))
//                .collect(Collectors.toList());
//    }

    public OrderSpecifier<?> findFollowerOrderType(int type) {
        switch (type) {
            case 2:
                return follow.createdAt.desc();
            case 3:
                return follow.createdAt.asc();
        }
        return follow.followerUser.nickname.asc();
    }

    public OrderSpecifier<?> findFollowingOrderType(int type) {
        switch (type) {
            case 2:
                return follow.createdAt.desc();
            case 3:
                return follow.createdAt.asc();
        }
        return follow.followingUser.nickname.asc();
    }


}
