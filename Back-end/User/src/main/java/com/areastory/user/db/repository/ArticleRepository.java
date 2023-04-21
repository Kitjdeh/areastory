package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Article;
import com.areastory.user.db.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ArticleRepository extends JpaRepository<Article, Long> {

    Page<Article> findAllByUserIdOrderByCreatedAtDesc(User user, Pageable pageable);
}
