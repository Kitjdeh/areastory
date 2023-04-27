package com.areastory.user.dto.common;

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
    private String image;
    private Long likeCount;
    private Long commentCount;
    private LocalDateTime createdAt;
}
