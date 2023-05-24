package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.ArticleReq;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.CaseBuilder;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import static com.areastory.article.db.entity.QArticle.article;
import static com.areastory.article.db.entity.QArticleLike.articleLike;
import static com.areastory.article.db.entity.QFollow.follow;


@Repository
@RequiredArgsConstructor
public class ArticleSupportRepositoryImpl implements ArticleSupportRepository {
    private final JPAQueryFactory query;

    @Override
    public Page<ArticleDto> findAll(ArticleReq articleReq, Pageable pageable) {
        List<ArticleDto> articleList = getArticlesQuery(articleReq.getUserId())
                .where(article.publicYn.eq(true), eqDosi(articleReq.getDosi()), eqSigungu(articleReq.getSigungu()),
                        eqDongeupmyeon(articleReq.getDongeupmyeon()))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> articleSize = query
                .select(article.count())
                .from(article);

        return PageableExecutionUtils.getPage(articleList, pageable, articleSize::fetchOne);
    }

    @Override
    public ArticleDto findById(Long userId, Long articleId) {
        return getArticlesQuery(userId)
                .where(article.articleId.eq(articleId))
                .fetchOne();
    }

    @Override
    public Page<UserDto> findAllLike(Long userId, Long articleId, Pageable pageable) {
        List<UserDto> likeList = query.select(Projections.constructor(UserDto.class,
                        articleLike.user.userId,
                        articleLike.user.nickname,
                        articleLike.user.profile,
                        new CaseBuilder()
                                .when(follow.followUser.userId.eq(userId))
                                .then(true)
                                .otherwise(false)
                ))
                .from(articleLike)
                .leftJoin(follow)
                .on(follow.followingUser.eq(articleLike.user), follow.followUser.userId.eq(userId))
                .where(articleLike.article.articleId.eq(articleId))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> likeListSize = query
                .select(articleLike.count())
                .from(articleLike)
                .where(articleLike.article.articleId.eq(articleId));

        return PageableExecutionUtils.getPage(likeList, pageable, likeListSize::fetchOne);
    }

    @Override
    public Page<ArticleDto> findMyLikeList(Long userId, Pageable pageable) {
        List<ArticleDto> myLikeList = getArticlesQuery(userId)
                .where(articleLike.user.userId.eq(userId))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> myLikeListSize = query
                .select(articleLike.count())
                .from(articleLike)
                .where(articleLike.user.userId.eq(userId));

        return PageableExecutionUtils.getPage(myLikeList, pageable, myLikeListSize::fetchOne);
    }

    @Override
    public Page<ArticleDto> findAllFollowArticleList(Long userId, Pageable pageable) {
        List<ArticleDto> followArticleList = getArticlesQuery(userId)
                .where(article.publicYn.eq(true), (follow.followUser.userId.eq(userId).or(article.user.userId.eq(userId))))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> articleSize = query
                .select(article.count())
                .from(article);

        return PageableExecutionUtils.getPage(followArticleList, pageable, articleSize::fetchOne);
    }

    private JPAQuery<ArticleDto> getArticlesQuery(Long userId) {
        //위치 정보 불러오기
        return query.select(Projections.constructor(ArticleDto.class,
                        article.articleId,
                        article.user.userId,
                        article.user.nickname,
                        article.user.profile,
                        article.content,
                        article.image,
                        article.thumbnail,
                        article.dailyLikeCount,
                        article.totalLikeCount,
                        article.commentCount,
                        new CaseBuilder()
                                .when(articleLike.user.userId.eq(userId))
                                .then(true)
                                .otherwise(false),
                        new CaseBuilder()
                                .when(follow.followUser.userId.eq(userId))
                                .then(true)
                                .otherwise(false),
                        article.createdAt,
                        article.dosi,
                        article.sigungu,
                        article.dongeupmyeon
                ))
                .from(article)
                .leftJoin(articleLike)
                .on(articleLike.user.userId.eq(userId), articleLike.article.eq(article))
                .leftJoin(follow)
                .on(follow.followingUser.eq(article.user), follow.followUser.userId.eq(userId));
    }


    private List<OrderSpecifier> getOrderSpecifier(Pageable pageable) {
        List<OrderSpecifier> articleOrders = new ArrayList<>();

        if (!pageable.getSort().isEmpty()) {
            for (Sort.Order order : pageable.getSort()) {
                Order direction = Order.DESC;
                switch (order.getProperty()) {
                    case "likeCount":
                        articleOrders.add(new OrderSpecifier<>(direction, article.dailyLikeCount));
                        articleOrders.add(new OrderSpecifier<>(direction, article.articleId));
                        break;
                    case "articleId":
                        articleOrders.add(new OrderSpecifier<>(direction, article.articleId));
                        articleOrders.add(new OrderSpecifier<>(direction, article.dailyLikeCount));
                        break;
                }
            }
        }
        return articleOrders;
    }

    private BooleanExpression eqDosi(String dosi) {
        if (StringUtils.hasText(dosi)) {
            return article.dosi.eq(dosi);
        }
        return null;
    }

    private BooleanExpression eqSigungu(String sigungu) {
        if (StringUtils.hasText(sigungu)) {
            return article.sigungu.eq(sigungu);
        }
        return null;
    }

    private BooleanExpression eqDongeupmyeon(String dongeupmyeon) {
        if (StringUtils.hasText(dongeupmyeon)) {
            return article.dongeupmyeon.eq(dongeupmyeon);
        }
        return null;
    }
}
