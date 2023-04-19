package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
public class Article extends BaseTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long articleId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String content;
    private String image;
    private Long likeCount;

    @ColumnDefault("0")
    private Long commentCount;

    @OneToMany(mappedBy = "article")
    private List<Comment> comment;

//    @OneToOne
//    @JoinColumn(name = "location_id")
//    private Location location;

    @Column(name = "do")
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;


    @Builder
    public Article(User user, String content, String image, String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
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
    }

    public void updateContent(String content) {
        this.content = content;
    }

    public void updateImage(String image) {
        this.image = image;
    }

    public void updateCommentCount() {
        this.commentCount++;
    }

    public void addLikeCount() {
        this.likeCount++;
    }

    public void removeLikeCount() {
        this.likeCount--;
    }
}
