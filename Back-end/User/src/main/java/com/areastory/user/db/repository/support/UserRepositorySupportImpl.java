package com.areastory.user.db.repository.support;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import static com.areastory.user.db.entity.QUser.user;

@Repository
@RequiredArgsConstructor
public class UserRepositorySupportImpl implements UserRepositorySupport {

    private final JPAQueryFactory queryFactory;

    @Override
    public void updateFollowAddCount(Long userId) {
        queryFactory
                .update(user)
                .set(user.followCount, user.followCount.add(1))
                .where(user.userId.eq(userId))
                .execute();
    }

    @Override
    public void updateFollowingAddCount(Long userId) {
        queryFactory
                .update(user)
                .set(user.followingCount, user.followingCount.add(1))
                .where(user.userId.eq(userId))
                .execute();
    }

    @Override
    public void updateFollowDisCount(Long userId) {
        queryFactory
                .update(user)
                .set(user.followCount, user.followCount.subtract(1))
                .where(user.userId.eq(userId))
                .execute();
    }

    @Override
    public void updateFollowingDisCount(Long userId) {
        queryFactory
                .update(user)
                .set(user.followingCount, user.followingCount.subtract(1))
                .where(user.userId.eq(userId))
                .execute();
    }
}
