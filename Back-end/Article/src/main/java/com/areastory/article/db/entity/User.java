package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Getter
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    private String nickname;
    private String profile;
    private String provider;
    private String providerId;

    @ColumnDefault("0")
    private Long followCount;
    @ColumnDefault("0")
    private Long followingCount;

    @Builder
    public User(String nickname, String profile, String provider, String providerId) {
        this.nickname = nickname;
        this.profile = profile;
        this.provider = provider;
        this.providerId = providerId;
    }
}
