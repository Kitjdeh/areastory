package com.areastory.article.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class ArticleReq {
    private Long userId;
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;

    @Builder
    public ArticleReq(Long userId, String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
        this.userId = userId;
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
    }
}
