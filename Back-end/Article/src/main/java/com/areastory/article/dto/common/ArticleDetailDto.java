package com.areastory.article.dto.common;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@NoArgsConstructor
@Getter
@SuperBuilder
public class ArticleDetailDto extends ArticleDto {

    private String comment;


    public ArticleDetailDto(String nickname, String content, String picture, Long likeCount, Long commentCount, String comment) {
        super(nickname, content, picture, likeCount, commentCount);
        this.comment = comment;
    }
}
