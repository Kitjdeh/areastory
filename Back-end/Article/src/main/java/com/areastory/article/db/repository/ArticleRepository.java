package com.areastory.article.db.repository;


import com.areastory.article.db.entity.Article;
import com.areastory.article.db.repository.surpport.ArticleCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleRepository extends JpaRepository<Article, Long>, ArticleCustomRepository {

}
