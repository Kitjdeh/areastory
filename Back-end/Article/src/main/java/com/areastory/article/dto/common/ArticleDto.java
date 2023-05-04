package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@NoArgsConstructor
@Getter
@Setter
public class ArticleDto extends ArticleCommonDto {
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;


    public ArticleDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long dailyLikeCount, Long totalLikeCount, Long commentCount, Boolean likeYn, Boolean followYn, LocalDateTime createdAt, String dosi, String sigungu, String dongeupmyeon) {
        super(articleId, userId, nickname, profile, content, image, dailyLikeCount, totalLikeCount, commentCount, likeYn, followYn, createdAt);
        this.dosi = dosi;
        this.sigungu = sigungu;
        this.dongeupmyeon = dongeupmyeon;
    }
}
