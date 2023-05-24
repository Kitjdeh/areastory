package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.CommentReq;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.CaseBuilder;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

import static com.areastory.article.db.entity.QComment.comment;
import static com.areastory.article.db.entity.QCommentLike.commentLike;
import static com.areastory.article.db.entity.QFollow.follow;

@Repository
@RequiredArgsConstructor
public class CommentSupportRepositoryImpl implements CommentSupportRepository {

    private final JPAQueryFactory query;

    @Override
    public Page<CommentDto> findAll(CommentReq commentReq, Pageable pageable) {
        List<CommentDto> comments = getCommentQuery(commentReq.getUserId())
                .where(comment.article.articleId.eq(commentReq.getArticleId()))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> commentSize = query
                .select(comment.count())
                .from(comment)
                .where(comment.article.articleId.eq(commentReq.getArticleId()));

        return PageableExecutionUtils.getPage(comments, pageable, commentSize::fetchOne);
    }

    @Override
    public CommentDto findOne(Long commentId, Long userId) {
        return getCommentQuery(userId).where(comment.commentId.eq(commentId)).fetchOne();
    }

    @Override
    public Page<UserDto> findAllLike(Long userId, Long commentId, Pageable pageable) {
        List<UserDto> likeList = query.select(Projections.constructor(UserDto.class,
                        commentLike.user.userId,
                        commentLike.user.nickname,
                        commentLike.user.profile,
                        new CaseBuilder()
                                .when(follow.followUser.userId.eq(userId))
                                .then(true)
                                .otherwise(false)
                ))
                .from(commentLike)
                .leftJoin(follow)
                .on(follow.followingUser.userId.eq(commentLike.user.userId))
                .where(commentLike.comment.commentId.eq(commentId), commentLike.user.userId.ne(userId))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> likeListSize = query
                .select(commentLike.count())
                .from(commentLike)
                .where(commentLike.comment.commentId.eq(commentId));

        return PageableExecutionUtils.getPage(likeList, pageable, likeListSize::fetchOne);
    }

    @Override
    public Page<CommentDto> findMyCommentList(Long userId, Pageable pageable) {
        List<CommentDto> comments = getCommentQuery(userId)
                .where(comment.user.userId.eq(userId))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> commentSize = query
                .select(comment.count())
                .from(comment)
                .where(comment.user.userId.eq(userId));

        return PageableExecutionUtils.getPage(comments, pageable, commentSize::fetchOne);
    }

    private List<OrderSpecifier> getOrderSpecifier(Pageable pageable) {
        List<OrderSpecifier> commentOrders = new ArrayList<>();

        if (!pageable.getSort().isEmpty()) {
            for (Sort.Order order : pageable.getSort()) {
                Order direction = Order.DESC;
                switch (order.getProperty()) {
                    case "likeCount":
                        commentOrders.add(new OrderSpecifier<>(direction, comment.likeCount));
                        commentOrders.add(new OrderSpecifier<>(direction, comment.commentId));
                        break;
                    case "commentId":
                        commentOrders.add(new OrderSpecifier<>(direction, comment.commentId));
                        commentOrders.add(new OrderSpecifier<>(direction, comment.likeCount));
                        break;
                }
            }
        }
        return commentOrders;
    }

    private JPAQuery<CommentDto> getCommentQuery(Long userId) {
        return query.select(Projections.constructor(CommentDto.class,
                        comment.commentId,
                        comment.article.articleId,
                        comment.user.userId,
                        comment.user.nickname,
                        comment.user.profile,
                        comment.content,
                        comment.likeCount,
                        comment.createdAt,
                        new CaseBuilder()
                                .when(commentLike.user.userId.eq(userId))
                                .then(true)
                                .otherwise(false)))
                .from(comment)
                .leftJoin(commentLike)
                .on(commentLike.user.userId.eq(userId), commentLike.comment.commentId.eq(comment.commentId));
    }
}
