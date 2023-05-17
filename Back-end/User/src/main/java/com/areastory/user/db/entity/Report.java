package com.areastory.user.db.entity;

import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Getter
@IdClass(ReportId.class)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
@Table(name = "report")
public class Report extends BaseTime implements Serializable {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "report_user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User reportUser;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_user_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User targetUser;
    @Column(name = "report_content")
    private String reportContent;

    public static Report report(User reportUser, User targetUser, String reportContent) {
        return Report.builder()
                .reportUser(reportUser)
                .targetUser(targetUser)
                .reportContent(reportContent)
                .build();
    }
}
