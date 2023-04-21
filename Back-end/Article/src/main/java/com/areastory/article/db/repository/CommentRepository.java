package com.areastory.article.db.repository;

import com.areastory.article.db.entity.Comment;
import com.areastory.article.db.repository.custom.CommentCustomRepository;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepository extends JpaRepository<Comment, Long>, CommentCustomRepository {
}
