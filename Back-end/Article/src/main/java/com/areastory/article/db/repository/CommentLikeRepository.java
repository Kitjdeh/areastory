package com.areastory.article.db.repository;

import com.areastory.article.db.entity.CommentLike;
import com.areastory.article.db.entity.CommentLikePK;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentLikeRepository extends JpaRepository<CommentLike, CommentLikePK> {
}
