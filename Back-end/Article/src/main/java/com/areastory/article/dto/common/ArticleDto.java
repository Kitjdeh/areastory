package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@NoArgsConstructor
@Getter
@Setter
public class ArticleDto {
    private Long articleId;
    private Long userId;
    private String nickname;
    private String profile;
    private String content;
    private String image;
    private Long dailyLikeCount;
    private Long totalLikeCount;
    private Long commentCount;
    private Boolean likeYn;
    private Boolean followYn;
    private LocalDateTime createdAt;
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;


    public ArticleDto(Long articleId, Long userId, String nickname, String profile, String content, String image, Long dailyLikeCount, Long totalLikeCount, Long commentCount, Boolean likeYn, Boolean followYn, LocalDateTime createdAt, String dosi, String sigungu, String dongeupmyeon) {
        this.articleId = articleId;
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.image = image;
        this.dailyLikeCount = dailyLikeCount;
        this.totalLikeCount = totalLikeCount;
        this.commentCount = commentCount;
        this.likeYn = likeYn;
        this.followYn = followYn;
        this.createdAt = createdAt;
        this.dosi = dosi;
        this.sigungu = sigungu;
        this.dongeupmyeon = dongeupmyeon;
    }
}
