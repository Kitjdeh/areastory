package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ArticleCommonDto {
    private Long articleId;
    private Long userId;
    private String nickname;
    private String profile;
    private String content;
    private String image;
    private Long likeCount;
    private Long commentCount;
    private Boolean isLike;
    private LocalDateTime createdAt;
}
