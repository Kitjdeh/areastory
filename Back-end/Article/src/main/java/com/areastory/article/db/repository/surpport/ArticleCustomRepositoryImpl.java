package com.areastory.article.db.repository.surpport;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.request.ArticleReq;
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

import java.util.List;

import static com.areastory.article.db.entity.QArticle.article;
import static com.areastory.article.db.entity.QArticleLike.articleLike;


@Repository
@RequiredArgsConstructor
public class ArticleCustomRepositoryImpl implements ArticleCustomRepository {
    private final JPAQueryFactory query;

    @Override
    public Page<ArticleDto> findAll(ArticleReq articleReq, Pageable pageable) {

        List<ArticleDto> articleList = getArticlesQuery(articleReq.getUserId())
                .where(eqDo(articleReq.getDoName()), eqSi(articleReq.getSi()), eqGun(articleReq.getGun()), eqGu(articleReq.getGu()),
                        eqDong(articleReq.getDong()), eqEup(articleReq.getEup()), eqMyeon(articleReq.getMyeon()))
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

    private JPAQuery<ArticleDto> getArticlesQuery(Long userId) {
        return query.select(Projections.constructor(ArticleDto.class,
                        article.articleId,
                        article.user.nickname,
                        article.user.profile,
                        article.content,
                        article.image,
                        article.likeCount,
                        article.commentCount,
                        article.createdAt,
                        new CaseBuilder()
                                .when(articleLike.userId.eq(userId))
                                .then(true)
                                .otherwise(false)))
                .from(article)
                .leftJoin(articleLike)
                .on(articleLike.userId.eq(userId), articleLike.articleId.eq(article.articleId));
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
