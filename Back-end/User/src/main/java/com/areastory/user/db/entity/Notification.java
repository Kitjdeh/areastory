package com.areastory.user.db.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

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
    @Column(length = 6)
    private String type;
    private Long articleId;
    private Long commentId;
    @Column(length = 200)
    private String image;
    private Boolean checked;
    @ManyToOne
    @JoinColumn(name = "other_user_id")
    private User otherUser;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public void check() {
        this.checked = true;
    }

}
