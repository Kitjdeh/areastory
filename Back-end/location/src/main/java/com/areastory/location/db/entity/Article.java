package com.areastory.location.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor
@DynamicInsert
@Table(name = "article"
//        indexes = {
//        @Index(name = "idx_location4", columnList = "daily_like_count"),
//        @Index(name = "idx_location2", columnList = "dosi,daily_like_count"),
//        @Index(name = "idx_location3", columnList = "dosi,sigungu,daily_like_count"),
//        @Index(name = "idx_location1", columnList = "dosi,sigungu,dongeupmyeon,daily_like_count")
//}
)
public class Article extends Location {
    @Id
    private Long articleId;
    private Long userId;
    @Column(length = 200)
    private String image;
    @Setter
    @Column(name = "daily_like_count")
    @ColumnDefault("0")
    private Long dailyLikeCount;
    private LocalDateTime createdAt;

    @Setter
    private Boolean publicYn;

    public Article(Long articleId, Location location, Long userId, String image, Long dailyLikeCount, LocalDateTime createdAt, Boolean publicYn) {
        super(location);
        this.articleId = articleId;
        this.userId = userId;
        this.image = image;
        this.dailyLikeCount = dailyLikeCount;
        this.createdAt = createdAt;
        this.publicYn = publicYn;
    }

    public static Builder articleBuilder() {
        return new Builder();
    }

    public static class Builder {
        private Long articleId;
        private Long userId;
        private String image;
        private Long dailyLikeCount;
        private Location location;
        private LocalDateTime createdAt;
        private Boolean publicYn;

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

        public Builder dailyLikeCount(Long dailyLikeCount) {
            this.dailyLikeCount = dailyLikeCount;
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

        public Builder publicYn(Boolean publicYn) {
            this.publicYn = publicYn;
            return this;
        }

        public Article build() {
            return new Article(articleId, location, userId, image, dailyLikeCount, createdAt, publicYn);
        }
    }
}
