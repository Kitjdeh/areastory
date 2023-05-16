package com.areastory.user.db.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@DynamicInsert
@Table(indexes = @Index(name = "idx_notification", columnList = "user_id, checked, notification_id"))
public class Notification extends BaseTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    private Long notificationId;
    @ColumnDefault("false")
    private Boolean checked;
    private String title;
    private String body;
    private LocalDateTime createdAt;
    private Long articleId;
    private Long commentId;
    @Column(name = "user_id")
    private Long userId;
    private Long otherUserId;
    private String type;

    public void check() {
        this.checked = true;
    }

}
