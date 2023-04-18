package com.areastory.article.dto.response;

import com.areastory.article.dto.common.ArticleDto;
import io.swagger.annotations.ApiModelProperty;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class ArticleResp {

    @ApiModelProperty(value = "한 페이지에서 나타낼수 있는 게시글의 수", example = "1")
    private Integer pageSize;
    @ApiModelProperty(value = "전체 페이지 번호", example = "1")
    private Integer totalPageNumber;
    @ApiModelProperty(value = "모든 게시글 개수", example = "1")
    private Long totalCount;

    private List<ArticleDto> articles;
}
