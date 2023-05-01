package com.areastory.article.db.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@IdClass(FollowPK.class)
public class Follow {
    @Id
    @JoinColumn(name = "follow_user_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User followUser;

    @Id
    @JoinColumn(name = "following_user_id")
    @ManyToOne
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User followingUser;
}
