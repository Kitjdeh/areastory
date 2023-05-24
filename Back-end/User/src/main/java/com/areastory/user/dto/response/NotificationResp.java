package com.areastory.user.dto.response;

import com.areastory.user.dto.common.NotificationDto;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Builder
@Getter
public class NotificationResp {
    private Integer pageSize;
    private Integer totalPageNumber;
    private Long totalCount;
    private Integer pageNumber;
    private Boolean nextPage;
    private Boolean previousPage;
    private List<NotificationDto> notifications;
}
