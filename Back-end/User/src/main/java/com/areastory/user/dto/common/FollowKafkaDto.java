package com.areastory.user.dto.common;

import lombok.*;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
@Builder
public class FollowKafkaDto {
    private String type;
    private Long followUserId;
    private Long followingUserId;
    private LocalDateTime createdAt;
}
