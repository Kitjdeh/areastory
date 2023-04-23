package com.areastory.user.controller;

import com.areastory.user.response.FollowerResp;
import com.areastory.user.response.FollowingResp;
import com.areastory.user.response.ResponseDefault;
import com.areastory.user.service.FollowService;
import com.areastory.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
@Slf4j
public class FollowController {

    private final FollowService followService;
    private final ResponseDefault responseDefault;
    private final UserService userService;

    /*
        팔로워 목록 조회
        한 페이지당 20개, 팔로워 이름 순으로 정렬
        이름으로 검색
     */
    @GetMapping("/follow/{userId}")
    public ResponseEntity<?> findFollowers(@PathVariable("userId") Long userId, @RequestParam int page, @RequestParam String search) {
        List<FollowerResp> followers = followService.findFollowers(userId, page, search);
        return responseDefault.success(true, "팔로워 목록 조회", followers);
    }

    /*
        팔로잉 목록 조회
        한 페이지당 20개
        팔로잉한 유저 이름 순, 팔로잉 시간 순, 역순으로 정렬
     */
    @GetMapping("/following/{userId}")
    public ResponseEntity<?> findFollowing(@PathVariable("userId") Long userId, @RequestParam int page, @RequestParam int type) {
        List<FollowingResp> following = followService.findFollowing(userId, page, type);
        return responseDefault.success(true, "팔로잉 목록 조회", following);
    }

    /*
        팔로잉 목록 조회
        검색 기능
        유저 이름 순
        => 무조건 이름 순인데, type을 받지않기 위해 새롭게 기능 추가
     */
    @GetMapping("/following/search/{userId}")
    public ResponseEntity<?> findFollowingBySearch(@PathVariable("userId") Long userId, @RequestParam int page, @RequestParam String search) {
        List<FollowingResp> following = followService.findFollowingBySearch(userId, page, search);
        return responseDefault.success(true, "팔로잉 검색 목록 조회", following);
    }

    /*
        팔로우 기능 (사용자 -> 상대방)
        사용자 (팔로워) : 팔로잉 증가
        상대방 (팔로잉) : 팔로워 증가
     */
    @PostMapping("/follow")
    public ResponseEntity<?> addFollower(@RequestParam Long userId, @RequestParam Long followingId) {

        if (!userService.findUser(followingId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }

        if (followService.addFollower(userId, followingId)) {
            return responseDefault.success(true, "팔로우 성공", null);
        } else {
            return responseDefault.fail(false, "이미 팔로우한 대상", null);
        }
    }

    /*
        사용자가 팔로우한 유저 끊기 (언팔로우)
        사용자 입장에서 팔로잉 유저 삭제
     */
    @DeleteMapping("/following")
    public ResponseEntity<?> deleteFollowing(@RequestParam Long userId, @RequestParam Long followingId) {
        if (!userService.findUser(followingId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }

        if (followService.deleteFollowing(userId, followingId)) {
            return responseDefault.success(true, "팔로잉 취소", null);
        } else {
            return responseDefault.fail(false, "이미 팔로우 취소한 대상", null);
        }
    }

    /*
        사용자를 팔로우한 유저 끊기
        사용자 입장에서 팔로워 유저 삭제
     */
    @DeleteMapping("/follow")
    public ResponseEntity<?> deleteFollower(@RequestParam Long userId, @RequestParam Long followerId) {
        if (!userService.findUser(followerId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }

        if (followService.deleteFollower(userId, followerId)) {
            return responseDefault.success(true, "팔로워 삭제", null);
        } else {
            return responseDefault.fail(false, "이미 삭제한 팔로워", null);
        }
    }
}
