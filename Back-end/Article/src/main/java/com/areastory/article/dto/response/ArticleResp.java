package com.areastory.article.dto.response;

import com.areastory.article.dto.common.ArticleRespDto;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class ArticleResp {

    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

    private List<ArticleRespDto> articles;

}
