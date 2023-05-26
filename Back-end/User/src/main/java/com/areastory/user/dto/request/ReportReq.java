package com.areastory.user.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReportReq {

    private Long reportUserId;
    private Long targetUserId;
    private String reportContent;
}
