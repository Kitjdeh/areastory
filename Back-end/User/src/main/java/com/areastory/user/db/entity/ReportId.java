package com.areastory.user.db.entity;

import lombok.*;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Builder
public class ReportId implements Serializable {

    private Long reportUser;
    private Long targetUser;
}
