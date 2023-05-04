package com.areastory.location.dto.common;

import lombok.*;

import javax.persistence.Column;
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
    private String image;
    private Long dailyLikeCount;
    private Long commentCount;
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;
    private LocalDateTime createdAt;
}
