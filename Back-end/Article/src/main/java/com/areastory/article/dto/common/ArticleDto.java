package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@NoArgsConstructor
@Getter
@Setter
public class ArticleDto extends ArticleCommonDto {
    //    private Long articleId;
//    private Long userId;
//    private String nickname;
//    private String profile;
//    private String content;
//    private String image;
//    private Long likeCount;
//    private Long commentCount;
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;

    public ArticleDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, Boolean isLike, LocalDateTime createdAt, String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
        super(articleId, userId, nickname, profile, content, image, likeCount, commentCount, isLike, createdAt);
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
    }

    //
//        private Boolean isLike;
//    private Boolean isOpen;
//    private LocalDateTime createdAt;
//
//    public ArticleDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, String doName, String si, String gun, String gu, String dong, String eup, String myeon, Boolean isLike, Boolean isOpen, LocalDateTime createdAt) {
//        this.articleId = articleId;
//        this.userId = userId;
//        this.nickname = nickname;
//        this.profile = profile;
//        this.content = content;
//        this.image = image;
//        this.likeCount = likeCount;
//        this.commentCount = commentCount;
//        this.doName = doName;
//        this.si = si;
//        this.gun = gun;
//        this.gu = gu;
//        this.dong = dong;
//        this.eup = eup;
//        this.myeon = myeon;
//        this.isLike = isLike;
//        this.isOpen = isOpen;
//        this.createdAt = createdAt;
////    }
}
