package com.areastory.user.db.repository.support;

import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import static com.areastory.user.db.entity.QNotification.notification;

@Repository
@RequiredArgsConstructor
public class NotificationRepositorySupportImpl implements NotificationRepositorySupport {
    private final JPAQueryFactory query;

    @Override
    public void checkAll(Long userId) {
        query.update(notification)
                .set(notification.checked, true)
                .where(notification.userId.eq(userId))
                .execute();
    }
}
