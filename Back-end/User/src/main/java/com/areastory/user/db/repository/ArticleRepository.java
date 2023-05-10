package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Article;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.support.ArticleRepositorySupport;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleRepository extends JpaRepository<Article, Long>, ArticleRepositorySupport {

    Page<Article> findByUser(User user, Pageable pageable);
}
