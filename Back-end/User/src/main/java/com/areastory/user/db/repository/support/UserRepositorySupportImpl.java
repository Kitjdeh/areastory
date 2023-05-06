package com.areastory.user.db.repository.support;


import com.areastory.user.db.entity.QFollow;
import com.areastory.user.db.entity.QUser;
import com.areastory.user.dto.response.UserDetailResp;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import static com.areastory.user.db.entity.QFollow.*;
import static com.areastory.user.db.entity.QUser.*;

@Repository
@RequiredArgsConstructor
public class UserRepositorySupportImpl implements UserRepositorySupport {

    private final JPAQueryFactory queryFactory;


    @Override
    public UserDetailResp findUserDetailResp(Long userId, Long myId) {

        QFollow follow = new QFollow("follow");
        BooleanExpression booleanExpression = follow.followerUser.userId.eq(myId).and(follow.followingUser.userId.eq(userId));

        return queryFactory
                .select(Projections.constructor(UserDetailResp.class,
                        user.userId,
                        user.nickname,
                        user.profile,
                        user.followCount,
                        user.followingCount,
                        ExpressionUtils.as(
                                JPAExpressions.selectOne()
                                        .from(follow)
                                        .where(booleanExpression)
                                        .exists(),
                                "followYn"
                        )))
                .from(user)
                .where(user.userId.eq(userId))
                .fetchOne();
    }
}
