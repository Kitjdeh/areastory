package com.areastory.user.dto.response;


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
public class FollowerPageResp {
    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

    private List<FollowerResp> followers;

    public static FollowerPageResp fromFollowerResp(Page<FollowerResp> followerResps) {
        return FollowerPageResp.builder()
                .followers(followerResps.getContent())
                .pageSize(followerResps.getPageable().getPageSize())
                .totalPageNumber(followerResps.getTotalPages())
                .totalCount(followerResps.getTotalElements())
                .pageNumber(followerResps.getPageable().getPageNumber())
                .nextPage(followerResps.hasNext())
                .previousPage(followerResps.hasPrevious())
                .build();
    }

}
