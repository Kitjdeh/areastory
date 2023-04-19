package com.areastory.article.db.repository.custom;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.CommentDto;
import com.areastory.article.dto.request.ArticleReq;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.CaseBuilder;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.areastory.article.db.entity.QArticle.article;
import static com.areastory.article.db.entity.QArticleLike.articleLike;
import static com.areastory.article.db.entity.QComment.comment;
import static com.areastory.article.db.entity.QCommentLike.commentLike;


@Repository
@RequiredArgsConstructor
public class ArticleCustomRepositoryImpl implements ArticleCustomRepository {
    private final JPAQueryFactory query;

    @Override
    public Page<ArticleDto> findAll(ArticleReq articleReq, Pageable pageable) {
        List<ArticleDto> test = query.select(Projections.constructor(ArticleDto.class,
                        article.articleId,
                        article.user.nickname,
                        article.user.profile,
                        article.content,
                        article.image,
                        article.likeCount,
                        article.commentCount,
                        new CaseBuilder()
                                .when(articleLike.user.userId.eq(articleReq.getUserId()))
                                .then(true)
                                .otherwise(false)))
                .from(article)
                .leftJoin(articleLike)
                .on(articleLike.user.userId.eq(articleReq.getUserId()), articleLike.article.eq(article))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();
        List<Long> articleIdList = test.stream().map(ArticleDto::getArticleId).collect(Collectors.toList());
        List<CommentDto> commentList = query.select(Projections.constructor(CommentDto.class,
                        comment.commentId,
                        comment.article.articleId,
                        comment.user.nickname,
                        comment.user.profile,
                        comment.content,
                        comment.likeCount,
                        new CaseBuilder()
                                .when(commentLike.user.userId.eq(articleReq.getUserId()))
                                .then(true)
                                .otherwise(false)
                ))
                .from(comment)
                .leftJoin(commentLike)
                .on(commentLike.user.userId.eq(articleReq.getUserId()), commentLike.comment.commentId.eq(comment.commentId))
                .where(comment.article.articleId.in(articleIdList))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();
        Map<Long, ArticleDto> map = new HashMap<>();
        test.forEach(o1 -> map.put(o1.getArticleId(), o1));
        commentList.forEach(o1 -> map.get(o1.getArticleId()).getComment().add(o1));

        JPAQuery<Long> articleSize = query
                .select(article.count())
                .from(article);

//        System.out.println("articleSize: " + articleSize);
        return PageableExecutionUtils.getPage(new ArrayList<>(map.values()), pageable, articleSize::fetchOne);
    }

    @Override
    public ArticleDto findById(Long userId, Long articleId) {
        ArticleDto articleDetail = query
                .select(Projections.constructor(ArticleDto.class,
                        article.articleId,
                        article.user.nickname,
                        article.user.profile,
                        article.content,
                        article.image,
                        article.likeCount,
                        article.commentCount,
                        new CaseBuilder()
                                .when(articleLike.user.userId.eq(userId))
                                .then(true)
                                .otherwise(false)
                ))
                .from(article)
                .leftJoin(articleLike)
                .on(articleLike.user.userId.eq(userId), articleLike.article.eq(article))
                .where(article.articleId.eq(articleId))
                .fetchOne();

        articleDetail.setComment(CommentList(articleId, 10L, comment.likeCount.desc()));
        return articleDetail;
    }

    private List<CommentDto> CommentList(Long articleId, Long limit, OrderSpecifier<Long> sort) {
        return query
                .select(Projections.constructor(CommentDto.class,
                        comment.content,
                        comment.likeCount,
                        comment.user.nickname,
                        comment.user.profile
                ))
                .from(comment)
                .where(comment.article.articleId.eq(articleId))
                .orderBy(sort)
                .limit(limit)
                .fetch();
    }

    private BooleanExpression eqDo(String doName) {
        if (StringUtils.hasText(doName)) {
            return article.doName.eq(doName);
        }
        return null;
    }

    private BooleanExpression eqSi(String si) {
        if (StringUtils.hasText(si)) {
            return article.si.eq(si);
        }
        return null;
    }

    private BooleanExpression eqGun(String gun) {
        if (StringUtils.hasText(gun)) {
            return article.gun.eq(gun);
        }
        return null;
    }

    private BooleanExpression eqGu(String gu) {
        if (StringUtils.hasText(gu)) {
            return article.gu.eq(gu);
        }
        return null;
    }

    private BooleanExpression eqDong(String dong) {
        if (StringUtils.hasText(dong)) {
            return article.dong.eq(dong);
        }
        return null;
    }

    private BooleanExpression eqEup(String eup) {
        if (StringUtils.hasText(eup)) {
            return article.eup.eq(eup);
        }
        return null;
    }

    private BooleanExpression eqMyeon(String myeon) {
        if (StringUtils.hasText(myeon)) {
            return article.myeon.eq(myeon);
        }
        return null;
    }
}
