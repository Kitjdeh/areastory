package com.areastory.article.dto.response;

import com.areastory.article.dto.common.UserDto;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class LikeResp {
    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

    private List<UserDto> users;
}
