package com.areastory.article.db.repository;


import com.areastory.article.db.entity.ArticleLike;
import com.areastory.article.db.entity.ArticleLikePK;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleLikeRepository extends JpaRepository<ArticleLike, ArticleLikePK> {

}
