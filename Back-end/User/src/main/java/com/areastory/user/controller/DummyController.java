package com.areastory.user.controller;

import com.areastory.user.db.entity.Follow;
import com.areastory.user.db.entity.User;
import com.areastory.user.db.repository.FollowRepository;
import com.areastory.user.db.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
public class DummyController {

    private final UserRepository userRepository;
    private final FollowRepository followRepository;

    @PostMapping("/user/dummy")
    public ResponseEntity<?> dummyUser() {
        for (int i = 1; i < 101; i++) {
            User user = new User(String.valueOf(i), "https://areastory-user.s3.ap-northeast-2.amazonaws.com/profile/acf029b1-129f-4344-aa40-e7fd8ec9c475.jpg", "kakao", 2756369011L, "aaa");
            userRepository.save(user);
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/follow/dummy")
    public ResponseEntity<?> dummyFollow() {
        for (int i = 5; i < 101; i++) {
            User followerUser = userRepository.findById(Long.valueOf(i)).orElseThrow();
            User followingUser = userRepository.findById(2L).orElseThrow();
            followRepository.save(Follow.follow(followerUser, followingUser));
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/following/dummy")
    public ResponseEntity<?> dummyFollowing() {
        for (int i = 5; i < 105; i++) {
            User followingUser = userRepository.findById(Long.valueOf(i)).orElseThrow();
            User followerUser = userRepository.findById(2L).orElseThrow();
            followRepository.save(Follow.follow(followerUser, followingUser));
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
