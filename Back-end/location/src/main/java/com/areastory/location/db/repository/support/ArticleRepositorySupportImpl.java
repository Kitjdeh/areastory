package com.areastory.location.db.repository.support;

import com.areastory.location.db.entity.ArticleSub;
import com.areastory.location.db.entity.QArticle;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.SubQueryExpression;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.JPQLQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.areastory.location.db.entity.QArticle.article;


@Repository
@RequiredArgsConstructor
public class ArticleRepositorySupportImpl implements ArticleRepositorySupport {
    private final JPAQueryFactory query;
//
//    @Override
//    public List<Article> test() {
////
////        JPQLQuery<Long> maxLikeCount = JPAExpressions
////                .select(article.dailyLikeCount.max())
////                .from(article)
////                .where(article.dosi.eq("서울특별시").and(article.sigungu.eq("강남구"))).groupBy(article.dosi, article.sigungu);
////
////        List<Article> result = query.select(article)
////                .from(article)
////                .join(article)
////                .on(article.dosi.eq(article.dosi).and(article.sigungu.eq(article.sigungu)).and(article.dailyLikeCount.eq(maxLikeCount)))
////                .groupBy(article.dosi, article.sigungu, article.dailyLikeCount)
////                .orderBy(article.articleId.desc())
////                .fetch();
//
//////
////
////        List<Article> result = query.select(article)
////                .from(article)
////                .join(
////                        JPAExpressions.select(article.dosi, article.sigungu, article.dailyLikeCount.max())
////                                .from(article)
////                                .where(article.dosi.eq("서울특별시").and(article.sigungu.eq("강남구")))
////                                .groupBy(article.dosi, article.sigungu), article)
////                .on(article.dosi.eq(article.dosi).and(article.sigungu.eq(article.sigungu)).and(article.dailyLikeCount.eq(article.dailyLikeCount.max())))
////                .orderBy(article.articleId.desc())
////                .fetch();
////        return result;
//    }

    //    SELECT a.*
//    FROM article a
//    JOIN (
//                    SELECT dosi, sigungu, MAX(daily_like_count) AS max_like_count
//    FROM article
//    WHERE dosi = '서울특별시' AND sigungu = '강남구'
//    GROUP BY dosi, sigungu
//) b ON a.dosi = b.dosi AND a.sigungu = b.sigungu AND a.daily_like_count = b.max_like_count
//    order by article_id desc;
    private List<Tuple> dongeupmyeonTuple(List<LocationDto> locationList, Long userId) {
        //받아오는 값에 따라서 바뀌어야함
        SubQueryExpression<Tuple> subquery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount.max())
                .from(article)
                .where(getWhereOr(locationList).and(article.userId.eq(userId))
                )
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon);

        return query
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount).in(subquery).and(article.userId.eq(userId))
                )
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon)
                .fetch();
    }

    private List<Tuple> sigunguTuple(List<LocationDto> locationList, Long userId) {
//        //받아오는 값에 따라서 바뀌어야함
//        SubQueryExpression<Tuple> subquery = JPAExpressions
//                .select(article.dosi, article.sigungu, article.dailyLikeCount.max())
//                .from(article)
//                .where(getWhereOr(locationList).and(article.userId.eq(userId))
//                )
//                .groupBy(article.dosi, article.sigungu);
//
//        return query
//                .select(article.dosi, article.sigungu, article.dailyLikeCount, article.image, article.articleId)
//                .from(article)
//                .where(
//                        Expressions.list(article.dosi, article.sigungu, article.dailyLikeCount).in(subquery).and(article.userId.eq(userId))
//                )
//                .groupBy(article.dosi, article.sigungu)
//                .fetch();
        QArticle qArticle = new QArticle("a");
        JPQLQuery<Tuple> subquery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dailyLikeCount.max())
                .from(article)
                .where(getWhereOr(locationList).and(article.userId.eq(userId))
                )
                .groupBy(article.dosi, article.sigungu);

        return query
                .select(article.dosi, article.sigungu, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        article.dosi.in(subquery.select(qArticle.dosi)),
                        article.sigungu.in(subquery.select(qArticle.sigungu)),
                        article.dailyLikeCount.in(subquery.select(qArticle.dailyLikeCount)),
                        article.userId.eq(userId)
                )
                .groupBy(article.dosi, article.sigungu)
                .fetch();
    }


    private List<Tuple> dosiTuple(List<LocationDto> locationList, Long userId) {
        //받아오는 값에 따라서 바뀌어야함
        SubQueryExpression<Tuple> subQuery = JPAExpressions
                .select(article.dosi, article.dailyLikeCount.max())
                .from(article)
                .where(getWhereOr(locationList).and(article.userId.eq(userId))
                )
                .groupBy(article.dosi);

        return query
                .select(article.dosi, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.dailyLikeCount).in(subQuery).and(article.userId.eq(userId))
                )
                .groupBy(article.dosi)
                .fetch();
    }


    @Override
    public List<LocationResp> getUserArticleList(Long userId, List<LocationDto> locationIdList) {
        if (locationIdList.size() == 0)
            return new ArrayList<>();
        List<Tuple> tuples;
        LocationDto locationDto = locationIdList.get(0);
        if (locationDto.getDongeupmyeon() != null) {
            tuples = dongeupmyeonTuple(locationIdList, userId);
            return tuples.stream().map(this::tupleToDongeupmyeonResp).collect(Collectors.toList());
        } else if (locationDto.getSigungu() != null) {
            tuples = sigunguTuple(locationIdList, userId);
            return tuples.stream().map(this::tupleToSigunguResp).collect(Collectors.toList());
        } else {
            tuples = dosiTuple(locationIdList, userId);
            return tuples.stream().map(this::tupleToDosiResp).collect(Collectors.toList());
        }
    }

    @Override
    public List<LocationResp> getDongeupmyeon() {

        SubQueryExpression<Tuple> subquery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon);

        List<Tuple> tuples = query
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount).in(subquery)
                )
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon)
                .fetch();
        return tuples.stream().map(this::tupleToDongeupmyeonResp).collect(Collectors.toList());
    }


    @Override
    public List<LocationResp> getSigungu() {
        SubQueryExpression<Tuple> subquery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi, article.sigungu);

        List<Tuple> tuples = query
                .select(article.dosi, article.sigungu, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.sigungu, article.dailyLikeCount).in(subquery)
                )
                .groupBy(article.dosi, article.sigungu)
                .fetch();

        return tuples.stream().map(this::tupleToSigunguResp).collect(Collectors.toList());
    }

    @Override
    public List<LocationResp> getDosi() {
        SubQueryExpression<Tuple> subquery = JPAExpressions
                .select(article.dosi, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi);

        List<Tuple> tuples = query
                .select(article.dosi, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.dailyLikeCount).in(subquery)
                )
                .groupBy(article.dosi)
                .fetch();
        return tuples.stream().map(this::tupleToDosiResp).collect(Collectors.toList());
    }

    @Override
    public LocationResp getDailyLikeCountData(String type, Long articleId, LocationDto locationDto, Long dailyLikeCount) {
        SubQueryExpression<Tuple> subQuery;
        Tuple tuple;
        if (type.equals("dongeupmyeon")) {
            subQuery = JPAExpressions
                    .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount.max())
                    .from(article)
                    .where(getWhereAnd(locationDto)
                            .and(article.dailyLikeCount.gt(dailyLikeCount))
                            .and(article.articleId.ne(articleId)))
                    .groupBy(article.dosi, article.sigungu, article.dongeupmyeon);

            tuple = query
                    .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount, article.image, article.articleId)
                    .from(article)
                    .where(
                            Expressions.list(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount)
                                    .in(subQuery)
                                    .and(getWhereAnd(locationDto))
                                    .and(article.articleId.ne(articleId))
                    )
                    .groupBy(article.dosi, article.sigungu, article.dongeupmyeon)
                    .fetchOne();

            return tupleToDongeupmyeonResp(tuple);
        } else if (type.equals("sigungu")) {
            subQuery = JPAExpressions
                    .select(article.dosi, article.sigungu, article.dailyLikeCount.max())
                    .from(article)
                    .where(getWhereAnd(locationDto)
                            .and(article.dailyLikeCount.gt(dailyLikeCount))
                            .and(article.articleId.ne(articleId)))
                    .groupBy(article.dosi, article.sigungu);

            tuple = query
                    .select(article.dosi, article.sigungu, article.dailyLikeCount, article.image, article.articleId)
                    .from(article)
                    .where(
                            Expressions.list(article.dosi, article.sigungu, article.dailyLikeCount)
                                    .in(subQuery)
                                    .and(getWhereAnd(locationDto))
                                    .and(article.articleId.ne(articleId))
                    )
                    .groupBy(article.dosi, article.sigungu)
                    .fetchOne();
            return tupleToSigunguResp(tuple);
        } else {
            subQuery = JPAExpressions
                    .select(article.dosi, article.dailyLikeCount.max())
                    .from(article)
                    .where(getWhereAnd(locationDto)
                            .and(article.dailyLikeCount.gt(dailyLikeCount))
                            .and(article.articleId.ne(articleId)))
                    .groupBy(article.dosi);

            tuple = query
                    .select(article.dosi, article.dailyLikeCount, article.image, article.articleId)
                    .from(article)
                    .where(
                            Expressions.list(article.dosi, article.dailyLikeCount)
                                    .in(subQuery)
                                    .and(getWhereAnd(locationDto))
                                    .and(article.articleId.ne(articleId))
                    )
                    .groupBy(article.dosi)
                    .fetchOne();
            return tupleToDosiResp(tuple);

        }
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

    private LocationResp tupleToDosiResp(Tuple tuples) {
        if (tuples == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(tuples.get(article.dosi))
                .likeCount(tuples.get(article.dailyLikeCount))
                .image(tuples.get(article.image))
                .articleId(tuples.get(article.articleId))
                .build();
    }

    private LocationResp tupleToSigunguResp(Tuple tuples) {
        if (tuples == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(tuples.get(article.dosi))
                .sigungu(tuples.get(article.sigungu))
                .likeCount(tuples.get(article.dailyLikeCount))
                .image(tuples.get(article.image))
                .articleId(tuples.get(article.articleId))
                .build();
    }


    private LocationResp tupleToDongeupmyeonResp(Tuple tuples) {
        if (tuples == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(tuples.get(article.dosi))
                .sigungu(tuples.get(article.sigungu))
                .dongeupmyeon(tuples.get(article.dongeupmyeon))
                .likeCount(tuples.get(article.dailyLikeCount))
                .image(tuples.get(article.image))
                .articleId(tuples.get(article.articleId))
                .build();
    }
}
