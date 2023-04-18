package com.areastory.article.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
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
}
