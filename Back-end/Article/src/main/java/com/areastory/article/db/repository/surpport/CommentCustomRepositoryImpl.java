package com.areastory.article.db.repository.surpport;

import com.areastory.article.dto.common.CommentDto;
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

import java.util.List;

import static com.areastory.article.db.entity.QComment.comment;
import static com.areastory.article.db.entity.QCommentLike.commentLike;

@Repository
@RequiredArgsConstructor
public class CommentCustomRepositoryImpl implements CommentCustomRepository {

    private final JPAQueryFactory query;

    @Override
    public Page<CommentDto> findAll(CommentReq commentReq, Pageable pageable) {
        List<CommentDto> comments = getCommentQuery(commentReq)
                .orderBy(getOrderSpecifier(pageable))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> commentSize = query
                .select(comment.count())
                .from(comment)
                .where(comment.article.articleId.eq(commentReq.getArticleId()));

        return PageableExecutionUtils.getPage(comments, pageable, commentSize::fetchOne);
    }

    private OrderSpecifier<?> getOrderSpecifier(Pageable pageable) {
        if (!pageable.getSort().isEmpty()) {
            for (Sort.Order order : pageable.getSort()) {
                Order direction = Order.DESC;
                switch (order.getProperty()) {
                    case "likeCount":
                        return new OrderSpecifier<>(direction, comment.likeCount);
                    case "createdAt":
                        return new OrderSpecifier<>(direction, comment.createdAt);
                }
            }
        }
        return null;
    }

    private JPAQuery<CommentDto> getCommentQuery(CommentReq commentReq) {
        return query.select(Projections.constructor(CommentDto.class,
                        comment.commentId,
                        comment.article.articleId,
                        comment.user.nickname,
                        comment.user.profile,
                        comment.content,
                        comment.likeCount,
                        comment.createdAt,
                        new CaseBuilder()
                                .when(commentLike.user.userId.eq(commentReq.getUserId()))
                                .then(true)
                                .otherwise(false)))
                .from(comment)
                .leftJoin(commentLike)
                .on(commentLike.user.userId.eq(commentReq.getUserId()), commentLike.comment.commentId.eq(comment.commentId))
                .where(comment.article.articleId.eq(commentReq.getArticleId()));
    }
}