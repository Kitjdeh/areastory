package com.areastory.user.dto.response;

import com.areastory.user.dto.common.ArticleDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;


@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ArticleResp {


    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

    private List<ArticleDto> articles;

    public static ArticleResp fromArticleDto(Page<ArticleDto> articleDtos) {
        return ArticleResp.builder()
                .articles(articleDtos.getContent())
                .pageSize(articleDtos.getPageable().getPageSize())
                .totalPageNumber(articleDtos.getTotalPages())
                .totalCount(articleDtos.getTotalElements())
                .pageNumber(articleDtos.getPageable().getPageNumber())
                .nextPage(articleDtos.hasNext())
                .previousPage(articleDtos.hasPrevious())
                .build();
    }

}
