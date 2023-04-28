package com.areastory.user.dto.common;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@EqualsAndHashCode
@ToString
@SuperBuilder
public class NotificationKafkaDto implements Serializable {
    private String type;
    private Long articleId;
    private Long commentId;
    private Long userId;
    private Long otherUserId;
    private String image;
}