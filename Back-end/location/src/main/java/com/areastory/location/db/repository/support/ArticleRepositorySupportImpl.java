package com.areastory.location.db.repository.support;

import com.areastory.location.db.entity.ArticleSub;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import static com.areastory.location.db.entity.QArticle.article;


@Repository
@RequiredArgsConstructor
public class ArticleRepositorySupportImpl implements ArticleRepositorySupport {
    private final JPAQueryFactory query;

    @Override
    public List<LocationResp> getArticleList(List<LocationDto> locationIdList) {
        List<ArticleSub> subList = getSubQuery(locationIdList).fetch();
        if (subList.size() == 0)
            return new ArrayList<>();
        return getMainQuery(subList).fetch();
    }

    @Override
    public List<LocationResp> getUserArticleList(Long userId, List<LocationDto> locationIdList) {
        List<ArticleSub> subList = getSubQuery(locationIdList).where(article.userId.eq(userId)).fetch();
        if (subList.size() == 0)
            return new ArrayList<>();
        return getMainQuery(subList).where(article.userId.eq(userId)).fetch();
    }

    private JPAQuery<LocationResp> getMainQuery(List<ArticleSub> subList) {
        return query
                .select(Projections.constructor(LocationResp.class,
                        article.doName,
                        article.si,
                        article.gun,
                        article.gu,
                        article.dong,
                        article.eup,
                        article.myeon,
                        article.image,
                        article.articleId
                ))
                .from(article)
                .where(getWhereOr(subList));
    }

    private JPAQuery<ArticleSub> getSubQuery(List<LocationDto> locationList) {
        return query
                .select(Projections.constructor(ArticleSub.class,
                        article.dailyLikeCount.max(),
                        article.doName,
                        article.si,
                        article.gun,
                        article.gu,
                        article.dong,
                        article.eup,
                        article.myeon
                ))
                .from(article)
                .where(getWhereOr(locationList))
                .groupBy(article.doName, article.si, article.gun, article.gu, article.dong, article.eup, article.myeon);
    }

    private BooleanExpression getWhereOr(List<? extends LocationDto> locationList) {
        BooleanExpression whereBoolean = null;
        for (LocationDto locationDto : locationList) {
            BooleanExpression whereAnd = getWhereAnd(locationDto);
            if (whereBoolean == null)
                whereBoolean = whereAnd;
            if (whereAnd == null)
                continue;
            whereBoolean = whereBoolean.or(whereAnd);
        }
        return whereBoolean;
    }

    private BooleanExpression getWhereAnd(LocationDto locationDto) {
        BooleanExpression booleanExpression = null;
        booleanExpression = eqDo(booleanExpression, locationDto.getDoName());
        booleanExpression = eqSi(booleanExpression, locationDto.getSi());
        booleanExpression = eqGun(booleanExpression, locationDto.getGun());
        booleanExpression = eqGu(booleanExpression, locationDto.getGu());
        booleanExpression = eqDong(booleanExpression, locationDto.getDong());
        booleanExpression = eqEup(booleanExpression, locationDto.getEup());
        booleanExpression = eqMyeon(booleanExpression, locationDto.getMyeon());
        if (locationDto instanceof ArticleSub)
            booleanExpression = eqLikeCount(booleanExpression, ((ArticleSub) locationDto).getDailyLikeCount());
        return booleanExpression;
    }

    private BooleanExpression eqLikeCount(BooleanExpression be, Long likeCount) {
        BooleanExpression eq = article.dailyLikeCount.eq(likeCount);
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqDo(BooleanExpression be, String doName) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(doName)) {
            eq = article.doName.eq(doName);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqSi(BooleanExpression be, String si) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(si)) {
            eq = article.si.eq(si);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqGun(BooleanExpression be, String gun) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(gun)) {
            eq = article.gun.eq(gun);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqGu(BooleanExpression be, String gu) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(gu)) {
            eq = article.gu.eq(gu);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqDong(BooleanExpression be, String dong) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(dong)) {
            eq = article.dong.eq(dong);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqEup(BooleanExpression be, String eup) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(eup)) {
            eq = article.eup.eq(eup);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqMyeon(BooleanExpression be, String myeon) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(myeon)) {
            eq = article.myeon.eq(myeon);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }


}
