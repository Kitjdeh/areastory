package com.areastory.article.dto.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@SuperBuilder
public class ArticleDto {

    private String nickname;
    //    private String location;
    private String content;
    private String picture;
    private Long likeCount;
    private Long commentCount;

}
