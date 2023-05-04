package com.areastory.article.dto.common;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

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
    private Long dailyLikeCount;
    private Long totalLikeCount;
    private Long commentCount;
    private Boolean likeYn;
    private Boolean followYn;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
}
