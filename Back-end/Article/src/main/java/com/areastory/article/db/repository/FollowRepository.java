package com.areastory.article.db.repository;

import com.areastory.article.db.entity.Follow;
import com.areastory.article.db.entity.FollowPK;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FollowRepository extends JpaRepository<Follow, FollowPK> {
}
