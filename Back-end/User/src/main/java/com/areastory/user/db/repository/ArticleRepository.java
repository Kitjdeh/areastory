package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Article;
import com.areastory.user.db.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleRepository extends JpaRepository<Article, Long> {

    Page<Article> findByUser(User user, Pageable pageable);
}
