package com.areastory.article.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@NoArgsConstructor
public class User {
    @Id
    private Long userId;
    @Setter
    @Column(length = 10)
    private String nickname;
    @Setter
    @Column(length = 200)
    private String profile;
    @Column(length = 10)
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
