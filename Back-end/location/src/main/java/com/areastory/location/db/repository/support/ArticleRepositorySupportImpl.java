package com.areastory.location.db.repository.support;

import com.areastory.location.db.entity.Article;
import com.areastory.location.db.entity.ArticleSub;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import com.querydsl.core.Tuple;
import com.querydsl.core.types.SubQueryExpression;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.areastory.location.db.entity.QArticle.article;
import static com.querydsl.jpa.JPAExpressions.select;


@Repository
@RequiredArgsConstructor
public class ArticleRepositorySupportImpl implements ArticleRepositorySupport {
    private final JPAQueryFactory query;
    private final EntityManager em;

    @Override
    public LocationResp getDailyLikeCountData(String type, Long articleId, LocationDto locationDto, Long dailyLikeCount) {
        SubQueryExpression<Tuple> subQuery;
        Tuple tuple;
        if (type.equals("dongeupmyeon")) {
            subQuery = select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount.max())
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
            subQuery = select(article.dosi, article.sigungu, article.dailyLikeCount.max())
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
            subQuery = select(article.dosi, article.dailyLikeCount.max())
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

    @Override
    public List<LocationResp> getInitDongeupmyeon() {

        SubQueryExpression<Tuple> subQuery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon);

        List<Tuple> tuples = query
                .select(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.sigungu, article.dongeupmyeon, article.dailyLikeCount).in(subQuery)
                )
                .groupBy(article.dosi, article.sigungu, article.dongeupmyeon)
                .fetch();

        return tuples.stream().map(this::tupleToDongeupmyeonResp).collect(Collectors.toList());
    }


    @Override
    public List<Article> getImage(List<LocationDto> locationList, Long userId) {
        if (locationList.size() == 0) {
            return null;
        }

        String jpql = "select a.* from article a join";
        String subJpql = getSubQuery(locationList);
        jpql += subJpql;
        Query result = em.createNativeQuery(jpql, Article.class)
                .setParameter("userId", userId);
        return (List<Article>) result.getResultList();
    }

    private String getSubQuery(List<LocationDto> locationList) {
        String subQuery;
        String whereJpql = " where (";
        String subGroupBy;
        String onJpql;
        String mainGroupBy;
        LocationDto locationDto = locationList.get(0);
        List<String> whereCondition;
        //dosi, sigungu, dongeupmyeon 다 들어왔을 경우
        if (locationDto.getDongeupmyeon() != null) {
            subQuery = "(select user_id, public_yn, dosi, sigungu, dongeupmyeon, MAX(daily_like_count) as max_like_count from article";
            whereCondition = getDongImage(locationList);
            subGroupBy = " group by dosi, sigungu, dongeupmyeon, user_id) b";
            onJpql = " on a.dosi=b.dosi and a.sigungu=b.sigungu and a.dongeupmyeon=b.dongeupmyeon and a.user_id=b.user_id and a.daily_like_count=b.max_like_count and a.public_yn=b.public_yn";
            mainGroupBy = " group by a.dosi, a.sigungu, a.dongeupmyeon, a.user_id";
        }
        //dosi, sigungu 만 들어왔을 경우
        else if (locationDto.getSigungu() != null) {
            subQuery = "(select user_id, public_yn, dosi, sigungu, MAX(daily_like_count) as max_like_count from article";
            whereCondition = getSiginguImage(locationList);
            subGroupBy = " group by dosi, sigungu, user_id) b";
            onJpql = " on a.dosi=b.dosi and a.sigungu=b.sigungu and a.user_id=b.user_id and a.daily_like_count=b.max_like_count and a.public_yn=b.public_yn";
            mainGroupBy = " group by a.dosi, a.sigungu, a.user_id";
        }
        // dosi 만 들어왔을 경우
        else {
            subQuery = "(select user_id, public_yn, dosi, MAX(daily_like_count) as max_like_count from article";
            whereCondition = getDosiImage(locationList);
            subGroupBy = " group by dosi, user_id) b";
            onJpql = " on a.dosi=b.dosi and a.user_id=b.user_id and a.daily_like_count=b.max_like_count and a.public_yn=b.public_yn";
            mainGroupBy = " group by a.dosi, a.user_id";
        }

        //where절 합치기
        if (!whereCondition.isEmpty()) {
            subQuery += whereJpql;
            subQuery += String.join(" or ", whereCondition);
            subQuery += ")";
            subQuery += " and user_id = :userId and public_yn = 1";
        }
        //서브쿼리의 group by 합치기
        subQuery += subGroupBy;

        //메인쿼리 on 절 합치기
        subQuery += onJpql;

        //메인 쿼리 group by 합치기
        subQuery += mainGroupBy;
        return subQuery;
    }

    /*
    DongImage : dosi, sigungu, dongeupmyeon 세개가 다 들어올 경우의 가공
     */
    private List<String> getDongImage(List<LocationDto> locationDtoList) {
        List<String> whereJpql = new ArrayList<>();
        //list 넘어온 주소들 가공해서 whereJpql에 넣기
        for (int i = 0; i < locationDtoList.size(); i++) {
            whereJpql.add("(dosi= \"" + locationDtoList.get(i).getDosi() + "\""
                    + " and sigungu = \"" + locationDtoList.get(i).getSigungu() + "\""
                    + " and dongeupmyeon = \"" + locationDtoList.get(i).getDongeupmyeon() + "\")");
        }

        return whereJpql;
    }

    /*
    SigunguImage : dosi, sigungu 두 개가 들어올 경우의 가공
     */
    private List<String> getSiginguImage(List<LocationDto> locationDtoList) {
        //list 넘어온 주소들 가공해서 whereJpql에 넣기
        List<String> whereJpql = new ArrayList<>();
        for (int i = 0; i < locationDtoList.size(); i++) {
            whereJpql.add("(dosi= \"" + locationDtoList.get(i).getDosi() + "\""
                    + " and sigungu = \"" + locationDtoList.get(i).getSigungu() + "\")");
        }
        return whereJpql;
    }

    /*
    DosiImage : dosi만 들어올 경우의 가공
     */
    private List<String> getDosiImage(List<LocationDto> locationDtoList) {
        //list 넘어온 주소들 가공해서 whereJpql에 넣기
        List<String> whereJpql = new ArrayList<>();
        for (int i = 0; i < locationDtoList.size(); i++) {
            whereJpql.add("(dosi= \"" + locationDtoList.get(i).getDosi() + "\")");
        }
        return whereJpql;
    }

    @Override
    public List<LocationResp> getInitSigungu() {
        SubQueryExpression<Tuple> subQuery = JPAExpressions
                .select(article.dosi, article.sigungu, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi, article.sigungu);

        List<Tuple> tuples = query
                .select(article.dosi, article.sigungu, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.sigungu, article.dailyLikeCount).in(subQuery)
                )
                .groupBy(article.dosi, article.sigungu)
                .fetch();

        return tuples.stream().map(this::tupleToSigunguResp).collect(Collectors.toList());
    }

    @Override
    public List<LocationResp> getInitDosi() {
        SubQueryExpression<Tuple> subQuery = JPAExpressions
                .select(article.dosi, article.dailyLikeCount.max())
                .from(article)
                .groupBy(article.dosi);

        List<Tuple> tuples = query
                .select(article.dosi, article.dailyLikeCount, article.image, article.articleId)
                .from(article)
                .where(
                        Expressions.list(article.dosi, article.dailyLikeCount).in(subQuery)
                )
                .groupBy(article.dosi)
                .fetch();
        return tuples.stream().map(this::tupleToDosiResp).collect(Collectors.toList());
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
