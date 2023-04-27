package com.areastory.user.db.entity;


import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
@Table
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId; // 유저ID (PK)
    @Setter
    private String nickname; // 닉네임
    @Setter
    private String profile; // 프로필 사진
    private String provider; // 소셜 로그인 종류
    private Long providerId; // 소셜 로그인 아이디
    private Long followCount; // 팔로우 수
    private Long followingCount; // 팔로잉 수
    private Boolean isValid;

    public User(String nickname, String profile, String provider, Long providerId) {
        this.nickname = nickname;
        this.profile = profile;
        this.provider = provider;
        this.providerId = providerId;
        this.followCount = 0L;
        this.followingCount = 0L;
        this.isValid = false;
    }

    public void deleteFollow() {
        this.followCount--;
    }

    public void addFollow() {
        this.followCount++;
    }

    public void deleteFollowing() {
        this.followCount--;
    }

    public void addFollowing() {
        this.followCount++;
    }

    public void setValid() {
        this.isValid = true;
    }
}
