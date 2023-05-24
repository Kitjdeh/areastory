package com.areastory.location.dto.common;

import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
@ToString
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
