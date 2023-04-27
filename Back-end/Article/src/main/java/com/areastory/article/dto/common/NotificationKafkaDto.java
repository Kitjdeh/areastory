package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@NoArgsConstructor
@Builder
@AllArgsConstructor
@Data
public class NotificationKafkaDto implements Serializable {
    private String type;
    private Long articleId;
    private Long commentId;
    private String nickname;
    private String profile;
    private String image;
}