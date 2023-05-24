package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class FollowKafkaDto {
    private String type;
    private Long followUserId;
    private Long followingUserId;
}
