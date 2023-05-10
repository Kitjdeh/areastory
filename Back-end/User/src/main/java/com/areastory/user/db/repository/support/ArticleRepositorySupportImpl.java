package com.areastory.user.db.repository.support;

import com.areastory.user.dto.common.ArticleDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.areastory.user.db.entity.QArticle.*;

@Repository
@RequiredArgsConstructor
public class ArticleRepositorySupportImpl implements  ArticleRepositorySupport{

    private final JPAQueryFactory queryFactory;


    @Override
    public Page<ArticleDto> getOtherUserArticleList(Long userId, Pageable pageable) {
        List<ArticleDto> articleDtoList = queryFactory
                .select(Projections.constructor(ArticleDto.class,
                        article.articleId,
                        article.image))
                .from(article)
                .where(article.user.userId.eq(userId).and(article.publicYn.eq(true)))
                .orderBy(article.createdAt.desc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> articleSize = queryFactory
                .select(article.count())
                .from(article);

        return PageableExecutionUtils.getPage(articleDtoList, pageable, articleSize::fetchOne);
    }
}
