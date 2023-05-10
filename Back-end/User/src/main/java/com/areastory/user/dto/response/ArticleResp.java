package com.areastory.user.dto.response;

import com.areastory.user.db.entity.Article;
import com.areastory.user.dto.common.ArticleDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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

}
