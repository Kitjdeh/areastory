package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
@DynamicInsert
@Table(name = "article"
//        , indexes = {@Index(name = "idx_location1", columnList = "daily_like_count"),
//        @Index(name = "idx_location2", columnList = "dosi,daily_like_count"),
//        @Index(name = "idx_location3", columnList = "dosi,sigungu,daily_like_count"),
//        @Index(name = "idx_location4", columnList = "dosi,sigungu,dongeupmyeon,daily_like_count")
//}
)
public class Article extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long articleId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Column(length = 100)
    private String content;
    @Column(length = 200)
    private String image;

    @Column(length = 200)
    private String thumbnail;
    @ColumnDefault("0")
    @Column(name = "daily_like_count")
    private Long dailyLikeCount;
    @ColumnDefault("0")
    private Long totalLikeCount;

    @ColumnDefault("0")
    private Long commentCount;

    @Column(length = 10)
    private String dosi;
    @Column(length = 10)
    private String sigungu;
    @Column(length = 10)
    private String dongeupmyeon;

    private Boolean publicYn;


    @Builder
    public Article(Long articleId, User user, String content, String image, String thumbnail, Long dailyLikeCount, Long totalLikeCount, Long commentCount, String dosi, String sigungu, String dongeupmyeon, Boolean publicYn) {
        this.articleId = articleId;
        this.user = user;
        this.content = content;
        this.image = image;
        this.thumbnail = thumbnail;
        this.dailyLikeCount = dailyLikeCount;
        this.totalLikeCount = totalLikeCount;
        this.commentCount = commentCount;
        this.dosi = dosi;
        this.sigungu = sigungu;
        this.dongeupmyeon = dongeupmyeon;
        this.publicYn = publicYn;
    }


    public void updateContent(String content) {
        this.content = content;
    }

    public void updatePublicYn(Boolean publicYn) {
        this.publicYn = publicYn;
    }

    public void addCommentCount() {
        this.commentCount++;
    }

    public void deleteCommentCount() {
        this.commentCount--;
    }

    public void addTotalLikeCount() {
        this.totalLikeCount++;
        this.dailyLikeCount++;
    }

    public void removeTotalLikeCount() {
        this.totalLikeCount--;
    }

    public void removeDailyLikeCount() {
        this.dailyLikeCount--;
    }
}
