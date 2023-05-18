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
    private String thumbnail;
    private Long likeCount;
    private Long commentCount;
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;
    private LocalDateTime createdAt;
    private Boolean publicYn;
}
