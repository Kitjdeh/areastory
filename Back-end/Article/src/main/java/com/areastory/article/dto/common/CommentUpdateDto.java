package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class CommentUpdateDto {
    private Long userId;
    private Long commentId;
    private String content;
}
