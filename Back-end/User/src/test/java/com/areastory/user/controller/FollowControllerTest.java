//package com.areastory.user.controller;
//
//import com.areastory.user.db.entity.Follow;
//import com.areastory.user.db.entity.User;
//import com.areastory.user.db.repository.FollowRepository;
//import com.areastory.user.db.repository.UserRepository;
//import com.areastory.user.response.FollowerResp;
//import com.areastory.user.response.FollowingResp;
//import com.areastory.user.service.FollowService;
//import com.querydsl.jpa.impl.JPAQueryFactory;
//import org.assertj.core.api.Assertions;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.data.domain.PageRequest;
//import org.springframework.data.domain.Sort;
//import org.springframework.test.annotation.Commit;
//import org.springframework.transaction.annotation.Transactional;
//
//import javax.persistence.EntityManager;
//
//import java.util.List;
//import java.util.stream.Collectors;
//
//import static org.assertj.core.api.Assertions.*;
//import static org.junit.jupiter.api.Assertions.*;
//
//
//@SpringBootTest
//@Transactional
//class FollowControllerTest {
//
//    @Autowired
//    EntityManager em;
//    @Autowired
//    UserRepository userRepository;
//    @Autowired
//    FollowRepository followRepository;
//    @Autowired
//    FollowService followService;
//
//    JPAQueryFactory queryFactory;
//
//    @Test
//    void findFollowers() {
//        List<FollowerResp> followers1 = followService.findFollowers(3L, 0, "");
//        em.flush();
//        em.clear();
//        assertThat(followers1.get(0).getNickname()).isEqualTo("user1");
//        assertThat(followers1.get(0).getCheck().booleanValue()).isFalse();
//        assertThat(followers1.get(1).getNickname()).isEqualTo("user2");
//        assertThat(followers1.get(1).getCheck().booleanValue()).isTrue();
//
//        List<FollowerResp> followers2 = followService.findFollowers(3L, 0, "2");
//        em.flush();
//        em.clear();
//        assertThat(followers2.get(0).getNickname()).isEqualTo("user2");
//        assertThat(followers2.get(0).getCheck().booleanValue()).isTrue();
//    }
//
//    @Test
//    void findFollowing() {
//        List<FollowingResp> following1 = followService.findFollowing(1L, 0, 1);
//        em.flush();
//        em.clear();
//        assertThat(following1.get(0).getNickname()).isEqualTo("user2");
//        assertThat(following1.get(1).getNickname()).isEqualTo("user3");
//
//        List<FollowingResp> following2 = followService.findFollowing(1L, 0, 2);
//        em.flush();
//        em.clear();
//        assertThat(following2.get(0).getNickname()).isEqualTo("user3");
//        assertThat(following2.get(1).getNickname()).isEqualTo("user2");
//
//        List<FollowingResp> following3 = followService.findFollowing(1L, 0, 3);
//        em.flush();
//        em.clear();
//        assertThat(following3.get(0).getNickname()).isEqualTo("user2");
//        assertThat(following3.get(1).getNickname()).isEqualTo("user3");
//    }
//
//    @Test
//    void findFollowingBySearch() {
//        List<FollowingResp> following1 = followService.findFollowingBySearch(1L, 0, "");
//        em.flush();
//        em.clear();
//        assertThat(following1.get(0).getNickname()).isEqualTo("user2");
//        assertThat(following1.get(1).getNickname()).isEqualTo("user3");
//        assertThat(following1.size()).isEqualTo(2);
//
//        List<FollowingResp> following2 = followService.findFollowingBySearch(1L, 0, "2");
//        em.flush();
//        em.clear();
//        assertThat(following2.get(0).getNickname()).isEqualTo("user2");
//        assertThat(following2.size()).isEqualTo(1);
//
//        List<FollowingResp> following3 = followService.findFollowingBySearch(1L, 0, "ser");
//        em.flush();
//        em.clear();
//        assertThat(following3.get(0).getNickname()).isEqualTo("user2");
//        assertThat(following3.get(1).getNickname()).isEqualTo("user3");
//        assertThat(following3.size()).isEqualTo(2);
//    }
//
//    @Test
//    @BeforeEach
//    void addFollower() {
//        /*
//            2 -> 3
//            1 -> 3
//            1 -> 2
//            3 -> 2
//         */
//
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        User user2 = new User("user2", "profile2", "google", 222L);
//        User user3 = new User("user3", "profile3", "kakao", 333L);
//        em.persist(user1);
//        em.persist(user2);
//        em.persist(user3);
//
//        em.flush();
//        em.clear();
//
//        followRepository.save(Follow.follow(user2, user3));
//        userRepository.updateFollowingAddCount(user2.getUserId());
//        userRepository.updateFollowAddCount(user3.getUserId());
//
//        followRepository.save(Follow.follow(user1, user3));
//        userRepository.updateFollowingAddCount(user1.getUserId());
//        userRepository.updateFollowAddCount(user3.getUserId());
//
//        followRepository.save(Follow.follow(user1, user2));
//        userRepository.updateFollowingAddCount(user1.getUserId());
//        userRepository.updateFollowAddCount(user2.getUserId());
//
//        followRepository.save(Follow.follow(user3, user2));
//        userRepository.updateFollowingAddCount(user3.getUserId());
//        userRepository.updateFollowAddCount(user2.getUserId());
//
//        assertThat(userRepository.findById(1L).orElse(null).getFollowCount()).isEqualTo(0);
//        assertThat(userRepository.findById(1L).orElse(null).getFollowingCount()).isEqualTo(2);
//
//        assertThat(userRepository.findById(2L).orElse(null).getFollowCount()).isEqualTo(2);
//        assertThat(userRepository.findById(2L).orElse(null).getFollowingCount()).isEqualTo(1);
//
//        assertThat(userRepository.findById(3L).orElse(null).getFollowCount()).isEqualTo(2);
//        assertThat(userRepository.findById(3L).orElse(null).getFollowingCount()).isEqualTo(1);
//
//        em.flush();
//        em.clear();
//
//    }
//
//    @Test
//    void deleteFollowing() {
//
//        followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(1L, 2L);
//        userRepository.updateFollowingDisCount(1L);
//        userRepository.updateFollowDisCount(2L);
//        assertThat(userRepository.findById(1L).orElse(null).getFollowingCount()).isEqualTo(1);
//        assertThat(userRepository.findById(2L).orElse(null).getFollowCount()).isEqualTo(1);
//
//        em.flush();
//        em.clear();
//
//        followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(2L, 3L);
//        userRepository.updateFollowingDisCount(2L);
//        userRepository.updateFollowDisCount(3L);
//        assertThat(userRepository.findById(2L).orElse(null).getFollowingCount()).isEqualTo(0);
//        assertThat(userRepository.findById(3L).orElse(null).getFollowCount()).isEqualTo(1);
//    }
//
//    @Test
//    void deleteFollower() {
//
//        followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(2L, 3L);
//        userRepository.updateFollowDisCount(3L);
//        userRepository.updateFollowingDisCount(2L);
//        assertThat(userRepository.findById(3L).orElse(null).getFollowCount()).isEqualTo(1);
//        assertThat(userRepository.findById(2L).orElse(null).getFollowingCount()).isEqualTo(0);
//
//        em.flush();
//        em.clear();
//
//        followRepository.deleteByFollowerUserId_UserIdAndFollowingUserId_UserId(1L, 3L);
//        userRepository.updateFollowDisCount(3L);
//        userRepository.updateFollowingDisCount(1L);
//        assertThat(userRepository.findById(3L).orElse(null).getFollowCount()).isEqualTo(0);
//        assertThat(userRepository.findById(1L).orElse(null).getFollowingCount()).isEqualTo(1);
//    }
//}