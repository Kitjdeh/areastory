package com.areastory.user.db.repository.support;


import com.areastory.user.db.entity.QFollow;
import com.areastory.user.dto.request.UserInfoReq;
import com.areastory.user.dto.response.FollowerResp;
import com.areastory.user.dto.response.UserDetailResp;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

import static com.areastory.user.db.entity.QArticle.*;
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
                        ExpressionUtils.count(article.articleId),
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
                .leftJoin(article)
                .on(article.user.userId.eq(userId))
                .where(user.userId.eq(userId))
                .fetchOne();
    }

    @Override
    public void updateUserInfo(Long userId, UserInfoReq userInfoReq, String saveUploadFile) {
        queryFactory
                .update(user)
                .set(user.nickname, userInfoReq.getNickname())
                .set(user.profile, saveUploadFile)
                .where(user.userId.eq(userId))
                .execute();
    }

    @Override
    public Page<FollowerResp> getUserBySearch(Long userId, Pageable pageable, String search) {
        List<FollowerResp> searchList = new ArrayList<>();
        List<FollowerResp> followerList = queryFactory
                .select(Projections.constructor(FollowerResp.class,
                        follow.followingUser.userId,
                        follow.followingUser.nickname,
                        follow.followingUser.profile,
                        Expressions.constant(true)))
                .from(follow)
                .where(follow.followerUser.userId.eq(userId), follow.followingUser.nickname.like(search))
                .orderBy(follow.createdAt.desc())
                .fetch();


        List<FollowerResp> notFollowerList = queryFactory
                .select(Projections.constructor(FollowerResp.class,
                        user.userId,
                        user.nickname,
                        user.profile,
                        Expressions.constant(false)))
                .from(user)
                .where(user.userId.notIn(getFollowingUserId(userId)), user.userId.ne(userId), user.nickname.like(search))
                .orderBy(user.nickname.asc())
                .fetch();

        searchList.addAll(followerList);
        searchList.addAll(notFollowerList);


        JPAQuery<Long> searchSize = queryFactory
                .select(user.count())
                .from(user);

        int offset = (int) pageable.getOffset();
        int limit = pageable.getPageSize();
        int startIndex = Math.min(offset, searchList.size());
        int endIndex = Math.min(offset + limit, searchList.size());
        List<FollowerResp> paginatedList = searchList.subList(startIndex, endIndex);

        return new PageImpl<>(paginatedList, pageable, searchList.size());
    }

    public List<Long> getFollowingUserId(Long userId) {
        return queryFactory
                .select(follow.followingUser.userId)
                .from(follow)
                .where(follow.followerUser.userId.eq(userId))
                .fetch();
    }
}
