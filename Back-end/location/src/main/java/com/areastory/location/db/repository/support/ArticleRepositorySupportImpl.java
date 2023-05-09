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
        if (locationIdList.size() == 0)
            return new ArrayList<>();
        JPAQuery<ArticleSub> subQuery = getSubQuery(locationIdList);
        if(!locationIdList.isEmpty()){
            LocationDto locationDto = locationIdList.get(0);
            if(locationDto.getDongeupmyeon() != null){
                subQuery = subQuery.groupBy(article.dosi, article.sigungu, article.dongeupmyeon);
            }else if(locationDto.getSigungu() != null){
                subQuery = subQuery.groupBy(article.dosi, article.sigungu);
            }else{
                subQuery = subQuery.groupBy(article.dosi);
            }
        }
        List<ArticleSub> subList = subQuery.fetch();
        System.out.println(subList.size());
        if (subList.size() == 0)
            return new ArrayList<>();
        JPAQuery<LocationResp> mainQuery = getMainQuery(subList);
        if(!locationIdList.isEmpty()){
            LocationDto locationDto = locationIdList.get(0);
            if(locationDto.getDongeupmyeon() != null){
                mainQuery = mainQuery.groupBy(article.dosi, article.sigungu, article.dongeupmyeon);
            }else if(locationDto.getSigungu() != null){
                mainQuery = mainQuery.groupBy(article.dosi, article.sigungu);
            }else{
                mainQuery = mainQuery.groupBy(article.dosi);
            }
        }
        return mainQuery.fetch();
    }

    @Override
    public List<LocationResp> getUserArticleList(Long userId, List<LocationDto> locationIdList) {
        List<ArticleSub> subList = getSubQuery(locationIdList).where(article.userId.eq(userId)).fetch();
        if (subList.size() == 0)
            return new ArrayList<>();
        return getMainQuery(subList).where(article.userId.eq(userId)).fetch();
    }

    private JPAQuery<LocationResp> getMainQuery(List<ArticleSub> subList) {
        JPAQuery<LocationResp> select = null;
        if(!subList.isEmpty()){
            LocationDto locationDto = subList.get(0);
            if(locationDto.getDongeupmyeon() != null){
                select= query.select(Projections.constructor(LocationResp.class,
                        article.dosi,
                        article.sigungu,
                        article.dongeupmyeon,
                        article.image,
                        article.dailyLikeCount.max()
                ));
            }else if(locationDto.getSigungu() != null){
                select =query.select(Projections.constructor(LocationResp.class,
                        article.dosi,
                        article.sigungu,
                        article.image,
                        article.dailyLikeCount.max()
                ));
            }else{
                select= query.select(Projections.constructor(LocationResp.class,
                        article.dosi,
                        article.image,
                        article.dailyLikeCount.max()
                ));
            }
        }
        return select
                .from(article)
                .where(getWhereOr(subList));
    }

    private JPAQuery<ArticleSub> getSubQuery(List<LocationDto> locationList) {
        JPAQuery<ArticleSub> select = null;
        if(!locationList.isEmpty()){
            LocationDto locationDto = locationList.get(0);
            if(locationDto.getDongeupmyeon() != null){
                select= query.select(Projections.constructor(ArticleSub.class,
                        article.dosi,
                        article.sigungu,
                        article.dongeupmyeon,
                        article.dailyLikeCount.max()
                ));
            }else if(locationDto.getSigungu() != null){
                select =query.select(Projections.constructor(ArticleSub.class,
                        article.dosi,
                        article.sigungu,
                        article.dailyLikeCount.max()
                ));
            }else{
                select= query.select(Projections.constructor(ArticleSub.class,
                        article.dosi,
                        article.dailyLikeCount.max()
                ));
            }
        }
        return select
                .from(article)
                .where(getWhereOr(locationList));
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
        booleanExpression = eqDosi(booleanExpression, locationDto.getDosi());
        booleanExpression = eqSigungu(booleanExpression, locationDto.getSigungu());
        booleanExpression = eqDongeupmyeon(booleanExpression, locationDto.getDongeupmyeon());
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

    private BooleanExpression eqDosi(BooleanExpression be, String dosi) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(dosi)) {
            eq = article.dosi.eq(dosi);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqSigungu(BooleanExpression be, String sigungu) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(sigungu)) {
            eq = article.sigungu.eq(sigungu);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }

    private BooleanExpression eqDongeupmyeon(BooleanExpression be, String dongeupmyeon) {
        BooleanExpression eq = null;
        if (StringUtils.hasText(dongeupmyeon)) {
            eq = article.dongeupmyeon.eq(dongeupmyeon);
        }
        if (be == null)
            return eq;
        if (eq == null)
            return be;
        return be.and(eq);
    }
}
