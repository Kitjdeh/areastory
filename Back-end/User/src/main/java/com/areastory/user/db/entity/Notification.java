package com.areastory.user.db.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(indexes = @Index(name = "idx_notification", columnList = "user_id, checked, notification_id"))
public class Notification extends BaseTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Long notificationId;
    private Boolean checked;
    private String title;
    private String body;
    private LocalDateTime createdAt;
    private Long articleId;
    private Long commentId;
    @Column(name = "user_id")
    private Long userId;

    public void check() {
        this.checked = true;
    }

}
