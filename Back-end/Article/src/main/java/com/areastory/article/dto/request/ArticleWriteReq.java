package com.areastory.article.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class ArticleWriteReq {
    private Long userId;
    private Boolean publicYn;
    private String content;
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;
}