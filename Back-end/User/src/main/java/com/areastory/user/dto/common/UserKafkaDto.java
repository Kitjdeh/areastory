package com.areastory.user.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserKafkaDto implements Serializable {
    private String type;
    private Long userId;
    private String nickname;
    private String profile;
    private String provider;
    private Long providerId;
}
