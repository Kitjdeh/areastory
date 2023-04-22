package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.ArticleLike;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.ArticleLikeRepository;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.response.ArticleResp;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.Pageable;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
@Configuration
@TestMethodOrder(MethodOrderer.OrderAnnotation.class) // @Order 에 의해서 실행 순서 결정
public class ArticleServiceImplTest {
    static List<User> userList;
    static List<Article> articleList;
    @Autowired
    ArticleService articleService;

    @BeforeAll
    static void setup(@Autowired UserRepository userRepository, @Autowired ArticleRepository articleRepository) {
        //user 정보 세팅
        userList = new ArrayList<>();
        userList.add(User.builder()
                .nickname("원원")
                .profile("사진1")
                .provider("kakao")
                .providerId("11111")
                .build());
        userList.add(User.builder()
                .nickname("투투")
                .profile("사진2")
                .provider("kakao")
                .providerId("22222")
                .build());
        userList.add(User.builder()
                .nickname("쓰쓰")
                .profile("사진3")
                .provider("kakao")
                .providerId("33333")
                .build());
        userList.add(User.builder()
                .nickname("포포")
                .profile("사진14")
                .provider("kakao")
                .providerId("44444")
                .build());
        userList.add(User.builder()
                .nickname("파파")
                .profile("사진5")
                .provider("kakao")
                .providerId("55555")
                .build());
        userList = userRepository.saveAll(userList);
        //게시글 저장
        articleList = new ArrayList<>();
        articleList.add(Article.builder()
                .user(userList.get(0))
                .content("경기도 1번 게시물")
                .image("경기도 1번 게시물 사진")
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .dong("이목동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(1))
                .content("경기도 2번 게시물")
                .image("경기도 2번 게시물 사진")
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .dong("이목동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(2))
                .content("경기도 3번 게시물")
                .image("경기도 3번 게시물 사진")
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .dong("이목동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(3))
                .content("경기도 4번 게시물")
                .image("경기도 4번 게시물 사진")
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .dong("파장동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(4))
                .content("경기도 5번 게시물")
                .image("경기도 5번 게시물 사진")
                .doName("경기도")
                .si("수원시")
                .gu("영통구")
                .dong("율전동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(0))
                .content("서울 관악구 1번 게시물")
                .image("서울 관악구 1번 게시물 사진")
                .si("서울시")
                .gu("관악구")
                .dong("신림동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(1))
                .content("서울 관악구 2번 게시물")
                .image("서울 관악구 2번 게시물 사진")
                .si("서울시")
                .gu("관악구")
                .dong("신림동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(2))
                .content("서울 관악구 3번 게시물")
                .image("서울 관악구 3번 게시물 사진")
                .si("서울시")
                .gu("관악구")
                .dong("신림동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(3))
                .content("서울 관악구 4번 게시물")
                .image("서울 관악구 4번 게시물 사진")
                .si("서울시")
                .gu("관악구")
                .dong("신림동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(4))
                .content("서울 관악구 5번 게시물")
                .image("강아지 사진 링크")
                .si("서울시")
                .gu("관악구")
                .dong("신림동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(0))
                .content("서울 강남구 1번 게시물")
                .image("서울 강남구 1번 게시물 사진")
                .si("서울시")
                .gu("강남구")
                .dong("역삼동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(1))
                .content("서울 강남구 2번 게시물")
                .image("서울 강남구 2번 게시물 사진")
                .si("서울시")
                .gu("강남구")
                .dong("역삼동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(2))
                .content("서울 강남구 3번 게시물")
                .image("서울 강남구 3번 게시물 사진")
                .si("서울시")
                .gu("강남구")
                .dong("역삼동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(3))
                .content("서울 강남구 4번 게시물")
                .image("서울 강남구 4번 게시물 사진")
                .si("서울시")
                .gu("강남구")
                .dong("역삼동")
                .build());
        articleList.add(Article.builder()
                .user(userList.get(4))
                .content("서울 강남구 5번 게시물")
                .image("서울 강남구 5번 게시물 사진")
                .si("서울시")
                .gu("강남구")
                .dong("역삼동")
                .build());
        articleList = articleRepository.saveAll(articleList);
    }

    /*
    like를 눌렀을 때 테스트
    like 중복 값 안들어가는 것 확인,
    like 눌렀을 때 article 의 likeCount 값 변경 되는지 확인
     */
    @Test
    @Order(1)
    @DisplayName("게시글 좋아요 테스트")
    void addLike(@Autowired ArticleLikeRepository articleLikeRepository, @Autowired ArticleRepository articleRepository) {
        List<ArticleLike> articleLikes = new ArrayList<>();
        //3번 게시물에 좋아요 5개
        articleLikes.add(new ArticleLike(userList.get(0).getUserId(), articleList.get(2).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(1).getUserId(), articleList.get(2).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(2).getUserId(), articleList.get(2).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(3).getUserId(), articleList.get(2).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(4).getUserId(), articleList.get(2).getArticleId()));

        //2번 게시물에 좋아요 3개 => 중복 체크
        articleLikes.add(new ArticleLike(userList.get(1).getUserId(), articleList.get(1).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(1).getUserId(), articleList.get(1).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(3).getUserId(), articleList.get(1).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(4).getUserId(), articleList.get(1).getArticleId()));

        //1번게시물에 좋아요 3개
        articleLikes.add(new ArticleLike(userList.get(1).getUserId(), articleList.get(0).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(2).getUserId(), articleList.get(0).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(3).getUserId(), articleList.get(0).getArticleId()));

        //4번 게시물에 좋아요 2개
        articleLikes.add(new ArticleLike(userList.get(2).getUserId(), articleList.get(3).getArticleId()));
        articleLikes.add(new ArticleLike(userList.get(3).getUserId(), articleList.get(3).getArticleId()));

        for (ArticleLike articleLike : articleLikes) {
            articleService.addArticleLike(articleLike.getUserId(), articleLike.getArticleId());
        }
        List<ArticleLike> checkArticleLikes = articleLikeRepository.findAll();
        List<Article> articles = articleRepository.findAll();
        assertEquals(13, checkArticleLikes.size());
        assertEquals(3, articles.get(0).getLikeCount());
        assertEquals(3, articles.get(1).getLikeCount());
        assertEquals(5, articles.get(2).getLikeCount());
        assertEquals(2, articles.get(3).getLikeCount());
    }

    /*
    like 취소 했을 때 테스트
    like 취소 시 값이 변경 되는지 테스트
     */
    @Test
    @Order(3)
    @DisplayName("게시글 취소 테스트")
    void deleteLike(@Autowired ArticleLikeRepository articleLikeRepository, @Autowired ArticleRepository articleRepository) {

    }

    /*
    모든 게시글 불러오기 테스트
    좋아요 순으로 정렬되는지 테스트
     */
    @Test
    @Order(2)
    @DisplayName("해당 지역 게시글들 보기")
    void getAllArticle() {
        List<ArticleReq> articleReqs = new ArrayList<>();
        List<ArticleResp> articleResps = new ArrayList<>();
        //경기도의 게시글 부르기
        articleReqs.add(ArticleReq.builder()
                .userId(userList.get(0).getUserId())
                .doName("경기도")
                .build());
        //경기도 수원시의 게시글 부르기
        articleReqs.add(ArticleReq.builder()
                .userId(userList.get(0).getUserId())
                .doName("경기도")
                .si("수원시")
                .build());
        //경기도 수원시 장안구의 게시글 부르기
        articleReqs.add(ArticleReq.builder()
                .userId(userList.get(0).getUserId())
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .build());
        //경기도 수원시 장안구 이목동의 게시글 부르기
        articleReqs.add(ArticleReq.builder()
                .userId(userList.get(0).getUserId())
                .doName("경기도")
                .si("수원시")
                .gu("장안구")
                .dong("이목동")
                .build());

        for (ArticleReq articleReq : articleReqs) {
            articleResps.add(articleService.selectAllArticle(articleReq, Pageable.ofSize(1)));
        }

        //경기도 게시글
        assertEquals(5, articleResps.get(0).getArticles().size());
        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
        //경기도 수원시 게시글
        assertEquals(5, articleResps.get(1).getArticles().size());
        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
        //경기도 수원시 장안구 게시글
        assertEquals(4, articleResps.get(2).getArticles().size());
        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
        //경기도 수원시 장안구 이목동 게시글
        assertEquals(3, articleResps.get(3).getArticles().size());
        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
    }
}


