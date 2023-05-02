package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.ArticleRespDto;
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
import java.util.Objects;
import java.util.stream.Collectors;

import static com.areastory.article.db.entity.QArticle.article;
import static com.areastory.article.db.entity.QArticleLike.articleLike;
import static com.areastory.article.db.entity.QFollow.follow;


@Repository
@RequiredArgsConstructor
public class ArticleSupportRepositoryImpl implements ArticleSupportRepository {
    private final JPAQueryFactory query;

    @Override
    public Page<ArticleRespDto> findAll(ArticleReq articleReq, Pageable pageable) {
        List<ArticleRespDto> articleList = getArticlesQuery(articleReq.getUserId())
                .where(article.publicYn.eq(true), eqDo(articleReq.getDoName()), eqSi(articleReq.getSi()), eqGun(articleReq.getGun()),
                        eqGu(articleReq.getGu()), eqEup(articleReq.getEup()), eqMyeon(articleReq.getMyeon()), eqDong(articleReq.getDong()))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch().stream().map(this::toArticleRespDto).collect(Collectors.toList());

        JPAQuery<Long> articleSize = query
                .select(article.count())
                .from(article);

        return PageableExecutionUtils.getPage(articleList, pageable, articleSize::fetchOne);
    }

    @Override
    public ArticleRespDto findById(Long userId, Long articleId) {
        return toArticleRespDto(Objects.requireNonNull(getArticlesQuery(userId)
                .where(article.articleId.eq(articleId))
                .fetchOne(), articleId + "의 게시글이 없음"));
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
                .on(follow.followingUser.userId.eq(articleLike.user.userId))
                .where(articleLike.article.articleId.eq(articleId), articleLike.user.userId.ne(userId))
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
    public Page<ArticleRespDto> findMyLikeList(Long userId, Pageable pageable) {
        List<ArticleRespDto> myLikeList = getArticlesQuery(userId)
                .where(articleLike.user.userId.eq(userId))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch().stream().map(this::toArticleRespDto).collect(Collectors.toList());

        JPAQuery<Long> myLikeListSize = query
                .select(articleLike.count())
                .from(articleLike)
                .where(articleLike.user.userId.eq(userId));

        return PageableExecutionUtils.getPage(myLikeList, pageable, myLikeListSize::fetchOne);
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
                        article.likeCount,
                        article.commentCount,
                        new CaseBuilder()
                                .when(articleLike.user.userId.eq(userId))
                                .then(true)
                                .otherwise(false),
                        article.createdAt,
                        article.doName,
                        article.si,
                        article.gun,
                        article.gu,
                        article.dong,
                        article.eup,
                        article.myeon
                ))
                .from(article)
                .leftJoin(articleLike)
                .on(articleLike.user.userId.eq(userId), articleLike.article.eq(article));
    }


    private List<OrderSpecifier> getOrderSpecifier(Pageable pageable) {
        List<OrderSpecifier> articleOrders = new ArrayList<>();

        if (!pageable.getSort().isEmpty()) {
            for (Sort.Order order : pageable.getSort()) {
                Order direction = Order.DESC;
                switch (order.getProperty()) {
                    case "likeCount":
                        articleOrders.add(new OrderSpecifier<>(direction, article.likeCount));
                        articleOrders.add(new OrderSpecifier<>(direction, article.articleId));
                        break;
                    case "articleId":
                        articleOrders.add(new OrderSpecifier<>(direction, article.articleId));
                        articleOrders.add(new OrderSpecifier<>(direction, article.likeCount));
                        break;
                }
            }
        }
        return articleOrders;
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
