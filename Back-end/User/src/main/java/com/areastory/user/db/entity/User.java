package com.areastory.user.db.entity;


import lombok.*;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
@Table(name = "users")
public class User {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId; // 유저ID (PK)
    private String nickname; // 닉네임
    private String profile; // 프로필 사진
    private String provider; // 소셜 로그인 종류
    @Column(name = "provider_id")
    private Long providerId; // 소셜 로그인 아이디
    @Column(name = "follow_count")
    private Long followCount; // 팔로우 수
    @Column(name = "following_count")
    private Long followingCount; // 팔로잉 수

    public User(String nickname, String profile, String provider, Long providerId) {
        this.nickname = nickname;
        this.profile = profile;
        this.provider = provider;
        this.providerId = providerId;
        this.followCount = 0L;
        this.followingCount = 0L;
    }
}
