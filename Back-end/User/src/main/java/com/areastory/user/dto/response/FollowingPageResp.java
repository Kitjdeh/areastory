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
public class FollowingPageResp {

    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;

    private List<FollowingResp> followings;

    public static FollowingPageResp fromFollowingResp(Page<FollowingResp> followingResps) {
        return FollowingPageResp.builder()
                .followings(followingResps.getContent())
                .pageSize(followingResps.getPageable().getPageSize())
                .totalPageNumber(followingResps.getTotalPages())
                .totalCount(followingResps.getTotalElements())
                .pageNumber(followingResps.getPageable().getPageNumber())
                .nextPage(followingResps.hasNext())
                .previousPage(followingResps.hasPrevious())
                .build();
    }

}
