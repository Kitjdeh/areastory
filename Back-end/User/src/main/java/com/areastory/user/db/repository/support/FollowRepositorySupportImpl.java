//package com.areastory.user.db.repository.support;
//
//
//import com.areastory.user.db.entity.Follow;
//import com.areastory.user.db.entity.QFollow;
//import com.areastory.user.response.FollowerResp;
//import com.querydsl.core.Tuple;
//import com.querydsl.core.types.ExpressionUtils;
//import com.querydsl.core.types.Projections;
//import com.querydsl.core.types.dsl.BooleanTemplate;
//import com.querydsl.jpa.impl.JPAQueryFactory;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Repository;
//
//import java.util.List;
//
//import static com.areastory.user.db.entity.QFollow.*;
//
//@Repository
//@RequiredArgsConstructor
//public class FollowRepositorySupportImpl implements FollowRepositorySupport {
//
//    private final JPAQueryFactory queryFactory;
//
//
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
//}
