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
    private String image;
    private Long likeCount;
    private Long commentCount;
    private LocalDateTime createdAt;
}
