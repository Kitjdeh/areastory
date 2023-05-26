package com.areastory.user.controller;

import com.areastory.user.dto.common.ArticleDto;
import com.areastory.user.dto.request.ReportReq;
import com.areastory.user.dto.request.UserInfoReq;
import com.areastory.user.dto.request.UserReq;
import com.areastory.user.dto.response.ArticleResp;
import com.areastory.user.dto.response.ResponseDefault;
import com.areastory.user.dto.response.UserResp;
import com.areastory.user.dto.response.UserSignUpResp;
import com.areastory.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
@Slf4j
public class UserController {

    private final UserService userService;
    private final ResponseDefault responseDefault;

    /*
        kakaoId 등, 소셜로그인 키를 통해 로그인 시도
        존재하지 않을 시, null 및 false 반환
        존재 시, 유저 정보 반환
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(Long providerId, String registrationToken) {
        UserResp userResp = userService.login(providerId, registrationToken);
        if (!userResp.getIsExist()) {
            return responseDefault.success(true, "신규 회원입니다.", userResp);
        }
        return responseDefault.success(true, "존재하는 회원입니다.", userResp);
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(Long userId) {
        userService.logout(userId);
        return responseDefault.success(true, "로그아웃에 성공했습니다.", null);
    }

    // 신규 회원일 경우 회원가입 시도
    @PostMapping("/sign-up")
    public ResponseEntity<?> signUp(@RequestPart UserReq userReq, @RequestPart(value = "profile") MultipartFile profile) {
        try {
            return responseDefault.success(true, "회원 가입 성공", userService.signUp(userReq, profile));
        } catch (Exception e) {
            System.out.println("파일 업로드 실패");
            throw new RuntimeException(e);
        }
//        return responseDefault.success(true, "회원 가입 성공", null);
    }

    // 유저 정보 조회
    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserDetail(@PathVariable("userId") Long userId, @RequestParam Long myId) {
        if (!userService.findUser(userId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }
        return responseDefault.success(true, "회원 정보 조회", userService.getUserDetail(userId, myId));
    }


    @PatchMapping("/{userId}")
    public ResponseEntity<?> updateUserInfo(@PathVariable("userId") Long userId, @RequestPart UserInfoReq userInfoReq, @RequestPart("profile") MultipartFile profile) {
        if (!userService.findUser(userId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }
        try {
            userService.updateUserInfo(userId, userInfoReq, profile);
            return responseDefault.success(true, "회원 정보 변경 성공", null);
        } catch (IOException e) {
            return responseDefault.fail(false, "실패", null);
        }
    }
    // 닉네임 변경
//    @PatchMapping("/{userId}")
//    public ResponseEntity<?> updateUserNickName(@PathVariable("userId") Long userId, @RequestBody UserInfoReq userInfoReq) {
//        userService.updateUserNickName(userId, userInfoReq.getNickname());
//        UserResp userResp = userService.getMyDetail(userId);
//        return responseDefault.success(true, "이름 변경", userResp);
//    }
//
//    //프로필 이미지 변경
//    @PatchMapping("/profile/{userId}")
//    public ResponseEntity<?> updateProfile(@PathVariable("userId") Long userId, @RequestPart("profile") MultipartFile profile) {
//        if (!userService.findUser(userId)) {
//            return responseDefault.notFound(false, "존재하지 않는 회원", null);
//        }
//        try {
//            userService.updateProfile(userId, profile);
//            return responseDefault.success(true, "프로필 변경 성공", null);
//        } catch (Exception e) {
//            return responseDefault.fail(false, "프로필 변경 실패", null);
//        }
//    }

    // 회원 탈퇴
    @DeleteMapping("/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable("userId") Long userId) {
        if (!userService.findUser(userId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }
        userService.deleteUser(userId);
        return responseDefault.success(true, "유저 삭제", null);
    }

    /*
        유저가 작성한 게시물 목록 조회
        한 페이지당 20개, 작성 시간 역순으로 정렬
     */
//    @GetMapping("/{userId}/articles")
//    public ResponseEntity<?> getArticleList(@PathVariable("userId") Long userId) {
//        if (!userService.findUser(userId)) {
//            return responseDefault.notFound(false, "존재하지 않는 회원", null);
//        }
//        List<ArticleResp> articleList = userService.getArticleList(userId);
//        return responseDefault.success(true, "본인의 게시물 목록 조회", articleList);
//    }

//    @GetMapping("/other/{userId}/articles")
//    public ResponseEntity<?> getOtherUserArticleList(@PathVariable("userId") Long userId) {
//        if (!userService.findUser(userId)) {
//            return responseDefault.notFound(false, "존재하지 않는 회원", null);
//        }
//        List<ArticleResp> articleList = userService.getOtherUserArticleList(userId);
//        return responseDefault.success(true, "다른 유저의 게시물 목록 조회", articleList);
//    }


    @GetMapping("/{userId}/articles")
    public ResponseEntity<?> getArticleList(@PathVariable("userId") Long userId, @RequestParam int page) {
        if (!userService.findUser(userId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }
        ArticleResp articleResp = userService.getArticleList(userId, page);
        return responseDefault.success(true, "본인의 게시물 목록 조회", articleResp);
    }

    /*
        다른 유저가 작성한 게시물 목록 조회
        한 페이지당 20개, 작성 시간 역순으로 정렬
     */
    @GetMapping("/other/{userId}/articles")
    public ResponseEntity<?> getOtherUserArticleList(@PathVariable("userId") Long userId, @RequestParam int page) {
        if (!userService.findUser(userId)) {
            return responseDefault.notFound(false, "존재하지 않는 회원", null);
        }
        ArticleResp articleResp = userService.getOtherUserArticleList(userId, page);
        return responseDefault.success(true, "다른 유저의 게시물 목록 조회", articleResp);
    }

    @GetMapping("/{userId}/search")
    public ResponseEntity<?> getUserBySearch(@PathVariable("userId") Long userId, @RequestParam int page, @RequestParam String search) {
        return responseDefault.success(true, "검색 성공", userService.getUserBySearch(userId, page, search));
    }

    @PostMapping("/report")
    public ResponseEntity<?> addReport(@RequestBody ReportReq reportReq) {
        if (userService.addReport(reportReq))
            return responseDefault.success(true, "신고 성공", null);
        return responseDefault.notFound(false, "이미 신고한 대상", null);
    }

}
