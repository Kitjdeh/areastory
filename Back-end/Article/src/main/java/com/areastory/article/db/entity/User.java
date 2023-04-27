package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@NoArgsConstructor
public class User {
    @Id
    private Long userId;
    @Setter
    private String nickname;
    @Setter
    private String profile;
    private String provider;
    private Long providerId;

    @Builder
    public User(Long userId, String nickname, String profile, String provider, Long providerId) {
        this.userId = userId;
        this.nickname = nickname;
        this.profile = profile;
        this.provider = provider;
        this.providerId = providerId;
    }
}
