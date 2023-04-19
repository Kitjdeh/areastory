package com.areastory.article.dto.common;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
@Builder
public class CommentDto {
    String nickname;
    String profile;
    String content;
    Long likeCount;


    public CommentDto(String nickname, String profile, String content, Long likeCount) {
        this.nickname = nickname;
        this.profile = profile;
        this.content = content;
        this.likeCount = likeCount;
    }
}
