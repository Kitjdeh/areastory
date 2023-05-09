package com.areastory.user.dto.common;

import lombok.*;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class UserKafkaDto implements Serializable {
    private String type;
    private Long userId;
    private String nickname;
    private String profile;
    private String provider;
    private Long providerId;
}
