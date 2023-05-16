package com.areastory.location.db.repository;

import com.areastory.location.db.entity.Article;
import com.areastory.location.db.repository.support.ArticleRepositorySupport;
import com.areastory.location.dto.common.LocationDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ArticleRepository extends JpaRepository<Article, Long>, ArticleRepositorySupport {

    @Query(value =
            "SELECT * FROM article a " +
                    "JOIN (" +
                    "  SELECT public_yn, user_id, dosi, sigungu, dongeupmyeon, MAX(daily_like_count) as max_count" +
                    "  FROM article " +
                    "  WHERE dosi = :#{#location.dosi} and sigungu = :#{#location.sigungu} and dongeupmyeon = :#{#location.dongeupmyeon} and user_id = :userId and public_yn = true " +
                    "  GROUP BY dosi, sigungu, dongeupmyeon, user_id" +
                    ") b ON a.dosi = b.dosi AND a.sigungu = b.sigungu AND a.dongeupmyeon = b.dongeupmyeon AND a.daily_like_count = b.max_count AND a.user_id = b.user_id AND a.public_yn = b.public_yn " +
                    " ORDER BY a.article_id DESC limit 1", nativeQuery = true)
    Article getDong(@Param("location") LocationDto locationDto, @Param("userId") Long userId);


    @Query(value =
            "SELECT * FROM article a " +
                    "JOIN (" +
                    "  SELECT public_yn, user_id, dosi, sigungu, MAX(daily_like_count) as max_count" +
                    "  FROM article " +
                    "  WHERE dosi = :#{#location.dosi} and sigungu = :#{#location.sigungu} and user_id = :userId and public_yn = true " +
                    "  GROUP BY dosi, sigungu, user_id" +
                    ") b ON a.dosi = b.dosi AND a.sigungu = b.sigungu AND a.daily_like_count = b.max_count AND a.user_id = b.user_id AND a.public_yn = b.public_yn " +
                    " ORDER BY a.article_id DESC limit 1", nativeQuery = true)
    Article getSigungu(@Param("location") LocationDto locationDto, @Param("userId") Long userId);


    @Query(value =
            "SELECT * FROM article a " +
                    "JOIN (" +
                    "  SELECT public_yn, user_id, dosi, MAX(daily_like_count) as max_count" +
                    "  FROM article " +
                    "  WHERE dosi = :#{#location.dosi} and user_id = :userId and public_yn = true " +
                    "  GROUP BY dosi, user_id" +
                    ") b ON a.dosi = b.dosi AND a.daily_like_count = b.max_count AND a.user_id = b.user_id AND a.public_yn = b.public_yn " +
                    " ORDER BY a.article_id DESC limit 1", nativeQuery = true)
    Article getDosi(@Param("location") LocationDto locationDto, @Param("userId") Long userId);
}