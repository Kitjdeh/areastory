package com.areastory.user.db.entity;


import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
@DynamicInsert
@Table(indexes = @Index(name = "idx_provider_id", columnList = "provider_id"))
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId; // 유저ID (PK)
    @Setter
    @Column(length = 10)
    private String nickname; // 닉네임
    @Setter
    @Column(length = 200)
    private String profile; // 프로필 사진
    @Column(length = 10)
    private String provider; // 소셜 로그인 종류
    @Column(name = "provider_id")
    private Long providerId; // 소셜 로그인 아이디
    @ColumnDefault("0")
    private Long followCount; // 팔로우 수
    @ColumnDefault("0")
    private Long followingCount; // 팔로잉 수
    @ColumnDefault("0")
    private Boolean isValid;
    private String hashKey;
    @Setter
    private String registrationToken;

    public User(String nickname, String profile, String provider, Long providerId, String registrationToken) {
        this.nickname = nickname;
        this.profile = profile;
        this.provider = provider;
        this.providerId = providerId;
        this.followCount = 0L;
        this.followingCount = 0L;
        this.isValid = false;
        this.registrationToken = registrationToken;
    }

    public void deleteFollow() {
        this.followCount--;
    }

    public void addFollow() {
        this.followCount++;
    }

    public void deleteFollowing() {
        this.followingCount--;
    }

    public void addFollowing() {
        this.followingCount++;
    }

    public void setValid() {
        this.isValid = true;
    }
}
