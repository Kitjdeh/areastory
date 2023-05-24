package com.areastory.location.db.repository;

import com.areastory.location.db.entity.Article;
import com.areastory.location.db.repository.support.ArticleRepositorySupport;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleRepository extends JpaRepository<Article, Long>, ArticleRepositorySupport {

}