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
@Table(indexes = {@Index(name = "idx_location", columnList = "do,si,gun,gu,dong,eup,myeon,daily_like_count")})
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
    @ColumnDefault("0")
    @Column(name = "daily_like_count")
    private Long dailyLikeCount;
    @ColumnDefault("0")
    private Long totalLikeCount;

    @ColumnDefault("0")
    private Long commentCount;

    @Column(name = "do", length = 7)
    private String doName;
    @Column(length = 10)
    private String si;
    @Column(length = 10)
    private String gun;
    @Column(length = 10)
    private String gu;
    @Column(length = 10)
    private String dong;
    @Column(length = 10)
    private String eup;
    @Column(length = 10)
    private String myeon;

    private Boolean publicYn;


    @Builder
    public Article(User user, String content, String image, String doName, String si, String gun, String gu, String dong, String eup, String myeon, Boolean publicYn) {
        this.user = user;
        this.content = content;
        this.image = image;
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
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
