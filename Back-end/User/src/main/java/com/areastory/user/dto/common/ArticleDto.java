package com.areastory.user.dto.common;

import com.areastory.user.db.entity.Article;
import com.areastory.user.dto.response.ArticleResp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ArticleDto {

    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

//    private List<ArticleDto> articles;
//
//    public static ArticleDto fromArticleDto(Page<ArticleDto> articleDtos) {
//        return ArticleResp.builder()
//                .articles(articleDtos.getContent())
//                .pageSize(articleDtos.getPageable().getPageSize())
//                .totalPageNumber(articleDtos.getTotalPages())
//                .totalCount(articleDtos.getTotalElements())
//                .pageNumber(articleDtos.getPageable().getPageNumber())
//                .nextPage(articleDtos.hasNext())
//                .previousPage(articleDtos.hasPrevious())
//                .build();
//    }

}
