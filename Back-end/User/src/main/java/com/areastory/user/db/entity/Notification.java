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
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long notificationId;
    private String type;
    private Long articleId;
    private Long commentId;
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
