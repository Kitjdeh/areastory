package com.areastory.location.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "article")
public class Article extends Location {
    @Id
    private Long articleId;
    private Long userId;
    private String image;
    @Setter
    private Long likeCount;
    private LocalDateTime createdAt;

    public Article(Long articleId, Location location, Long userId, String image, Long likeCount, LocalDateTime createdAt) {
        super(location);
        this.articleId = articleId;
        this.userId = userId;
        this.image = image;
        this.likeCount = likeCount;
        this.createdAt = createdAt;
    }

    public static Builder articleBuilder() {
        return new Builder();
    }

    public static class Builder {
        private Long articleId;
        private Long userId;
        private String image;
        private Long likeCount;
        private Location location;
        private LocalDateTime createdAt;

        public Builder userId(Long userId) {
            this.userId = userId;
            return this;
        }

        public Builder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public Builder image(String image) {
            this.image = image;
            return this;
        }

        public Builder likeCount(Long likeCount) {
            this.likeCount = likeCount;
            return this;
        }

        public Builder location(Location location) {
            this.location = location;
            return this;
        }

        public Builder articleId(Long articleId) {
            this.articleId = articleId;
            return this;
        }

        public Article build() {
            return new Article(articleId, location, userId, image, likeCount, createdAt);
        }
    }
}
