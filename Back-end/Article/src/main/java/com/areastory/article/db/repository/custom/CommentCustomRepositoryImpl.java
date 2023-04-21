package com.areastory.article.db.repository.custom;

import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.request.CommentReq;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.CaseBuilder;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> commentSize = query
                .select(comment.count())
                .from(comment)
                .where(comment.articleId.eq(commentReq.getArticleId()));

        return PageableExecutionUtils.getPage(comments, pageable, commentSize::fetchOne);
    }

    private JPAQuery<CommentDto> getCommentQuery(CommentReq commentReq) {
        return query.select(Projections.constructor(CommentDto.class,
                        comment.commentId,
                        comment.articleId,
                        comment.user.nickname,
                        comment.user.profile,
                        comment.content,
                        comment.likeCount,
                        comment.createdAt,
                        new CaseBuilder()
                                .when(commentLike.userId.eq(commentReq.getUserId()))
                                .then(true)
                                .otherwise(false)))
                .from(comment)
                .leftJoin(commentLike)
                .on(commentLike.userId.eq(commentReq.getUserId()), commentLike.commentId.eq(comment.commentId))
                .where(comment.articleId.eq(commentReq.getArticleId()));
    }
}
