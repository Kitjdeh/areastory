package com.areastory.user.dto.common;

import lombok.*;

import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@EqualsAndHashCode
@ToString
public class NotificationKafkaDto implements Serializable {
    private String type;
    private Long articleId;
    private Long commentId;
    private String nickname;
    private String profile;
    private String image;
}