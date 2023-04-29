package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@NoArgsConstructor
@Getter
@Setter
public class ArticleDto extends ArticleCommonDto {
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;

    public ArticleDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long likeCount, Long commentCount, Boolean likeYn, LocalDateTime createdAt, String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
        super(articleId, userId, nickname, profile, content, image, likeCount, commentCount, likeYn, createdAt);
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
    }
}
