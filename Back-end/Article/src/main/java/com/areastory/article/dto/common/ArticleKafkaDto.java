package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ArticleKafkaDto implements Serializable {
    private String type;
    private Long articleId;
    private Long userId;
    private String content;
    private String thumbnail;
    private Long dailyLikeCount;
    private Long commentCount;
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;
    private LocalDateTime createdAt;
    private Boolean publicYn;
}
