package com.areastory.user.db.repository.support;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.QFollow;
import com.areastory.user.db.entity.User;
import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.CaseBuilder;
import com.querydsl.core.types.dsl.Expressions;
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

//    public BooleanExpression checkFollow(Long userId, Long followingUserId) {
////        System.out.println("userIdList : "+ userIdList);
////        BooleanExpression booleanExpression = Expressions.asBoolean(queryFactory
////                .select(follow)
////                .from(follow)
////                .where(follow.followerUserId.userId.eq(userId))
////                .fetchFirst() != null);
////        System.out.println("booleanExpression : " + booleanExpression);
////        return booleanExpression;
//        Expressions.asBoolean(queryFactory
//                .select(follow)
//                .from(follow)
//                .where(follow.followerUserId.userId.eq(userId), follow.followingUserId.userId.eq())
//    }
    @Override
    public List<FollowerResp> findFollwerResps(Long userId, PageRequest pageRequest, String search) {
        List<Tuple> tuples = queryFactory
                .select(Projections.constructor(FollowerResp.class),
                        follow.followerUserId.userId,
                        follow.followerUserId.nickname,
                        follow.followerUserId.profile)
                .from(follow)
                .where(follow.followingUserId.userId.eq(userId), follow.followerUserId.nickname.like(search))
                .orderBy(follow.followerUserId.nickname.asc())
                .offset(pageRequest.getOffset())
                .limit(pageRequest.getPageSize())
                .fetch();

        for (Tuple tuple : tuples) {
            System.out.println("tuple : " + tuple);
        }
        return tuples.stream()
                .map(tuple -> new FollowerResp(tuple.get(1, Long.class),
                                            tuple.get(2, String.class),
                                            tuple.get(3, String.class)))
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


//    @Override
//    public List<FollowerResp> findFollwerResps(Long userId, List<Long> follwerIdList, int page) {
////        queryFactory
////                .select(Projections.constructor(FollowerResp.class),
////                        follow.followerUserId.userId,
////                        follow.followerUserId.nickname,
////                        follow.followerUserId.profile,
////                        )
////                .from(follow)
//        List<Tuple> fetch = queryFactory
//                .select(Projections.constructor(FollowerResp.class),
//                        follow.followerUserId.userId,
//                        follow.followerUserId.nickname,
//                        follow.followerUserId.profile,
//                        ExpressionUtils.as(
//                                BooleanTemplate
//                        ))
//                .from(follow)
//                .where(follow.followingUserId.userId.eq(userId))
//                .orderBy(follow.followerUserId.nickname.asc())
//                .offset(page * 20)
//                .limit(page)
//                .fetch();
//    }
}
