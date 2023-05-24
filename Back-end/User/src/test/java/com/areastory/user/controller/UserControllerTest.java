//package com.areastory.user.controller;
//
//import com.areastory.user.db.entity.Article;
//import com.areastory.user.db.entity.QUser;
//import com.areastory.user.db.entity.User;
//import com.areastory.user.db.repository.UserRepository;
//import com.areastory.user.response.UserResp;
//import com.querydsl.core.Tuple;
//import com.querydsl.core.types.Projections;
//import com.querydsl.core.types.dsl.BooleanExpression;
//import com.querydsl.core.types.dsl.Expressions;
//import com.querydsl.jpa.impl.JPAQueryFactory;
//import org.assertj.core.api.Assertions;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.test.annotation.Commit;
//import org.springframework.transaction.annotation.Transactional;
//
//import javax.persistence.EntityManager;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//import static com.areastory.user.db.entity.QArticle.*;
//import static com.areastory.user.db.entity.QUser.*;
//import static org.assertj.core.api.Assertions.*;
//
//@SpringBootTest
//@Transactional
//class UserControllerTest {
//
//    @Autowired
//    EntityManager em;
//    @Autowired
//    UserRepository userRepository;
//    JPAQueryFactory queryFactory;
//
//    @Test
//    void login() {
//        queryFactory = new JPAQueryFactory(em);
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        User user2 = new User("user2", "profile2", "google", 222L);
//        em.persist(user1);
//        em.persist(user2);
//
//        em.flush();
//        em.clear();
//
//        User findUser1 = userRepository.findByProviderId(111L).orElse(null);
//        assertThat(findUser1.getNickname()).isEqualTo("user1");
//        assertThat(findUser1.getProfile()).isEqualTo("profile1");
//        assertThat(findUser1.getProvider()).isEqualTo("kakao");
//
//        User findUser2 = userRepository.findByProviderId(333L).orElse(null);
//        assertThat(findUser2).isEqualTo(null);
//
//    }
//
//    @Test
//    void signUp() {
//    }
//
//    @Test
//    void getUserDetail() {
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        User user2 = new User("user2", "profile2", "google", 222L);
//        em.persist(user1);
//        em.persist(user2);
//
//        em.flush();
//        em.clear();
//
//        User findUser1 = userRepository.findById(1L).orElse(null);
//        assertThat(findUser1.getNickname()).isEqualTo("user1");
//        assertThat(findUser1.getProfile()).isEqualTo("profile1");
//        assertThat(findUser1.getProvider()).isEqualTo("kakao");
//
//        User findUser2 = userRepository.findById(2L).orElse(null);
//        assertThat(findUser2.getNickname()).isEqualTo("user2");
//        assertThat(findUser2.getProfile()).isEqualTo("profile2");
//        assertThat(findUser2.getProvider()).isEqualTo("google");
//
//    }
//
//    @Test
//    void updateUserNickName() {
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        em.persist(user1);
//
//        em.flush();
//        em.clear();
//
//        userRepository.updateNickname(1L, "updateNickname");
//        User findUser = userRepository.findById(1L).orElse(null);
//        assertThat(findUser.getNickname()).isEqualTo("updateNickname");
//    }
//
//    @Test
//    void updateProfile() {
//    }
//
//    @Test
//    void deleteUser() {
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        em.persist(user1);
//
//        em.flush();
//        em.clear();
//
//        userRepository.deleteById(1L);
//        User findUser = userRepository.findById(1L).orElse(null);
//        assertThat(findUser).isEqualTo(null);
//    }
//
//    @Test
//    void getArticleList() {
//        queryFactory = new JPAQueryFactory(em);
//        User user1 = new User("user1", "profile1", "kakao", 111L);
//        em.persist(user1);
//        Article article1 = new Article("a", "b", user1);
//        Article article2 = new Article("aa", "bb", user1);
//        Article article3 = new Article("aaa", "bbb", user1);
//
//        article1.setCreatedAt(LocalDateTime.now());
//        em.persist(article1);
//        article2.setCreatedAt(LocalDateTime.now());
//        em.persist(article2);
//        article3.setCreatedAt(LocalDateTime.now());
//        em.persist(article3);
//
//        em.flush();
//        em.clear();
//
//        List<Article> articleList = queryFactory
//                .select(article)
//                .from(article)
//                .where(article.userId.userId.eq(user1.getUserId()))
//                .orderBy(article.createdAt.desc())
//                .fetch();
//
//        assertThat(articleList.get(0).getArticleId()).isEqualTo(3);
//        assertThat(articleList.get(1).getArticleId()).isEqualTo(2);
//        assertThat(articleList.get(2).getArticleId()).isEqualTo(1);
//    }
//}