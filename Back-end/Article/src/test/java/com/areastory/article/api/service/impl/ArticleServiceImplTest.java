//package com.areastory.article.api.service.impl;
//
//import com.areastory.article.api.service.ArticleService;
//import com.areastory.article.db.entity.Article;
//import com.areastory.article.db.entity.ArticleLike;
//import com.areastory.article.db.entity.User;
//import com.areastory.article.db.repository.ArticleLikeRepository;
//import com.areastory.article.db.repository.ArticleRepository;
//import com.areastory.article.db.repository.UserRepository;
//import com.areastory.article.dto.common.ArticleDto;
//import com.areastory.article.dto.request.ArticleReq;
//import com.areastory.article.dto.request.ArticleUpdateParam;
//import com.areastory.article.dto.response.ArticleResp;
//import com.areastory.article.util.FileUtil;
//import org.junit.jupiter.api.*;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.data.domain.PageRequest;
//import org.springframework.data.domain.Pageable;
//import org.springframework.data.domain.Sort;
//import org.springframework.mock.web.MockMultipartFile;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//import static org.junit.jupiter.api.Assertions.assertFalse;
//
//@SpringBootTest
//@Configuration
//@DisplayName("게시글 테스트")
//@TestMethodOrder(MethodOrderer.OrderAnnotation.class) // @Order 에 의해서 실행 순서 결정
//public class ArticleServiceImplTest {
//    static List<User> userList;
//    static List<Article> articleList;
//    @Autowired
//    ArticleService articleService;
//
//    @BeforeAll
//    static void setup(@Autowired FileUtil fileUtil, @Autowired UserRepository userRepository, @Autowired ArticleRepository articleRepository) throws IOException {
//        //user 정보 세팅
//        userList = new ArrayList<>();
//        userList.add(User.builder()
//                .userId(1L)
//                .nickname("원원")
//                .profile("사진1")
//                .provider("kakao")
//                .providerId(11111L)
//                .build());
//        userList.add(User.builder()
//                .userId(2L)
//                .nickname("투투")
//                .profile("사진2")
//                .provider("kakao")
//                .providerId(22222L)
//                .build());
//        userList.add(User.builder()
//                .userId(3L)
//                .nickname("쓰쓰")
//                .profile("사진3")
//                .provider("kakao")
//                .providerId(33333L)
//                .build());
//        userList.add(User.builder()
//                .userId(4L)
//                .nickname("포포")
//                .profile("사진14")
//                .provider("kakao")
//                .providerId(44444L)
//                .build());
//        userList.add(User.builder()
//                .userId(5L)
//                .nickname("파파")
//                .profile("사진5")
//                .provider("kakao")
//                .providerId(55555L)
//                .build());
//        userList = userRepository.saveAll(userList);
//        //게시글 저장
//        articleList = new ArrayList<>();
//        articleList.add(Article.builder()
//                .user(userList.get(0))
//                .content("경기도 1번 게시물")
//                .image("경기도 1번 게시물 사진")
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .dong("이목동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(1))
//                .content("경기도 2번 게시물")
//                .image("경기도 2번 게시물 사진")
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .dong("이목동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(2))
//                .content("경기도 3번 게시물")
//                .image("경기도 3번 게시물 사진")
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .dong("이목동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(3))
//                .content("경기도 4번 게시물")
//                .image("경기도 4번 게시물 사진")
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .dong("파장동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(4))
//                .content("경기도 5번 게시물")
//                .image("경기도 5번 게시물 사진")
//                .doName("경기도")
//                .si("수원시")
//                .gu("영통구")
//                .dong("율전동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(0))
//                .content("서울 관악구 1번 게시물")
//                .image("서울 관악구 1번 게시물 사진")
//                .si("서울시")
//                .gu("관악구")
//                .dong("신림동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(1))
//                .content("서울 관악구 2번 게시물")
//                .image("게시글 사진")
//                .si("서울시")
//                .gu("관악구")
//                .dong("신림동")
//                .build());
//
//        articleList.add(Article.builder()
//                .user(userList.get(2))
//                .content("서울 관악구 3번 게시물")
//                .image("서울 관악구 3번 게시물 사진")
//                .si("서울시")
//                .gu("관악구")
//                .dong("신림동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(3))
//                .content("서울 관악구 4번 게시물")
//                .image("서울 관악구 4번 게시물 사진")
//                .si("서울시")
//                .gu("관악구")
//                .dong("신림동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(4))
//                .content("서울 관악구 5번 게시물")
//                .image("강아지 사진 링크")
//                .si("서울시")
//                .gu("관악구")
//                .dong("신림동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(0))
//                .content("서울 강남구 1번 게시물")
//                .image("서울 강남구 1번 게시물 사진")
//                .si("서울시")
//                .gu("강남구")
//                .dong("역삼동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(1))
//                .content("서울 강남구 2번 게시물")
//                .image("서울 강남구 2번 게시물 사진")
//                .si("서울시")
//                .gu("강남구")
//                .dong("역삼동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(2))
//                .content("서울 강남구 3번 게시물")
//                .image("서울 강남구 3번 게시물 사진")
//                .si("서울시")
//                .gu("강남구")
//                .dong("역삼동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(3))
//                .content("서울 강남구 4번 게시물")
//                .image("서울 강남구 4번 게시물 사진")
//                .si("서울시")
//                .gu("강남구")
//                .dong("역삼동")
//                .build());
//        articleList.add(Article.builder()
//                .user(userList.get(4))
//                .content("서울 강남구 5번 게시물")
//                .image("서울 강남구 5번 게시물 사진")
//                .si("서울시")
//                .gu("강남구")
//                .dong("역삼동")
//                .build());
//        articleRepository.saveAll(articleList);
//    }
//
//    /*
//    like를 눌렀을 때 테스트
//    like 중복 값 안들어가는 것 확인,
//    like 눌렀을 때 article 의 likeCount 값 변경 되는지 확인
//     */
//    @Test
//    @Order(1)
//    @DisplayName("게시글 좋아요 테스트")
//    void addLike(@Autowired ArticleLikeRepository articleLikeRepository, @Autowired ArticleRepository articleRepository) {
//        List<ArticleLike> articleLikes = new ArrayList<>();
//        //3번 게시물에 좋아요 5개
//        articleLikes.add(new ArticleLike(userList.get(0), articleList.get(2)));
//        articleLikes.add(new ArticleLike(userList.get(1), articleList.get(2)));
//        articleLikes.add(new ArticleLike(userList.get(2), articleList.get(2)));
//        articleLikes.add(new ArticleLike(userList.get(3), articleList.get(2)));
//        articleLikes.add(new ArticleLike(userList.get(4), articleList.get(2)));
//
//        //2번 게시물에 좋아요 3개 => 중복 체크
//        articleLikes.add(new ArticleLike(userList.get(1), articleList.get(1)));
//        articleLikes.add(new ArticleLike(userList.get(1), articleList.get(1)));
//        articleLikes.add(new ArticleLike(userList.get(3), articleList.get(1)));
//        articleLikes.add(new ArticleLike(userList.get(4), articleList.get(1)));
//
//        //1번게시물에 좋아요 3개
//        articleLikes.add(new ArticleLike(userList.get(1), articleList.get(0)));
//        articleLikes.add(new ArticleLike(userList.get(2), articleList.get(0)));
//        articleLikes.add(new ArticleLike(userList.get(3), articleList.get(0)));
//
//        //4번 게시물에 좋아요 2개
//        articleLikes.add(new ArticleLike(userList.get(2), articleList.get(3)));
//        articleLikes.add(new ArticleLike(userList.get(3), articleList.get(3)));
//
//        for (ArticleLike articleLike : articleLikes) {
//            articleService.addArticleLike(articleLike.getUser().getUserId(), articleLike.getArticle().getArticleId());
//        }
//        List<ArticleLike> checkArticleLikes = articleLikeRepository.findAll();
//        List<Article> articles = articleRepository.findAll();
//        assertEquals(13, checkArticleLikes.size());
//        assertEquals(3, articles.get(0).getLikeCount());
//        assertEquals(3, articles.get(1).getLikeCount());
//        assertEquals(5, articles.get(2).getLikeCount());
//        assertEquals(2, articles.get(3).getLikeCount());
//    }
//
//    /*
//    like 취소 했을 때 테스트
//    like 취소 시 값이 변경 되는지 테스트
//     */
//    @Test
//    @Order(3)
//    @DisplayName("게시글 좋아요 취소 테스트")
//    void deleteLike(@Autowired ArticleLikeRepository articleLikeRepository, @Autowired ArticleRepository articleRepository) {
//        List<ArticleLike> articleLikesDelete = new ArrayList<>();
//
//        //3번 게시물 좋아요 삭제 (5개 => 3개)
//        articleLikesDelete.add(new ArticleLike(userList.get(0), articleList.get(2)));
//        articleLikesDelete.add(new ArticleLike(userList.get(1), articleList.get(2)));
//        //좋아요를 안누른 게시물 좋아요 취소해보기(1번 사람이 2번 게시물)
//        articleLikesDelete.add(new ArticleLike(userList.get(0), articleList.get(1)));
//        //4번 게시물 2번 연속 삭제 (똑같은 사람이 두번 눌렀을 때)
//        articleLikesDelete.add(new ArticleLike(userList.get(2), articleList.get(3)));
//        articleLikesDelete.add(new ArticleLike(userList.get(2), articleList.get(3)));
//
//        for (ArticleLike articleLikeDelete : articleLikesDelete) {
//            articleService.deleteArticleLike(articleLikeDelete.getUser().getUserId(), articleLikeDelete.getArticle().getArticleId());
//        }
//        List<ArticleLike> checkArticleLikes = articleLikeRepository.findAll();
//        List<Article> articles = articleRepository.findAll();
//
//        assertEquals(10, checkArticleLikes.size());
//        assertEquals(3, articles.get(2).getLikeCount());
//        assertEquals(3, articles.get(1).getLikeCount());
//        assertEquals(1, articles.get(3).getLikeCount());
//    }
//
//    /*
//    모든 게시글 불러오기 테스트
//    좋아요 순으로 정렬되는지 테스트
//     */
//    @Test
//    @Order(2)
//    @DisplayName("해당 지역 모든 게시글 보기 테스트")
//    void getAllArticle() {
//        List<ArticleReq> articleReqs = new ArrayList<>();
//        List<ArticleResp> articleResps = new ArrayList<>();
//        //경기도의 게시글 부르기
//        articleReqs.add(ArticleReq.builder()
//                .userId(userList.get(0).getUserId())
//                .doName("경기도")
//                .build());
//        //경기도 수원시의 게시글 부르기
//        articleReqs.add(ArticleReq.builder()
//                .userId(userList.get(0).getUserId())
//                .doName("경기도")
//                .si("수원시")
//                .build());
//        //경기도 수원시 장안구의 게시글 부르기
//        articleReqs.add(ArticleReq.builder()
//                .userId(userList.get(0).getUserId())
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .build());
//        //경기도 수원시 장안구 이목동의 게시글 부르기
//        articleReqs.add(ArticleReq.builder()
//                .userId(userList.get(0).getUserId())
//                .doName("경기도")
//                .si("수원시")
//                .gu("장안구")
//                .dong("이목동")
//                .build());
//
//        Pageable pageable = PageRequest.of(0, 15, Sort.Direction.DESC, "likeCount");
//        for (ArticleReq articleReq : articleReqs) {
//            articleResps.add(articleService.selectAllArticle(articleReq, pageable));
//        }
//
//        //경기도 게시글
//        assertEquals(5, articleResps.get(0).getArticles().size());
//        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
//        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
//        //경기도 수원시 게시글
//        assertEquals(5, articleResps.get(1).getArticles().size());
//        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
//        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
//        //경기도 수원시 장안구 게시글
//        assertEquals(4, articleResps.get(2).getArticles().size());
//        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
//        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
//        //경기도 수원시 장안구 이목동 게시글
//        assertEquals(3, articleResps.get(3).getArticles().size());
//        assertEquals(5, articleResps.get(0).getArticles().get(0).getLikeCount());
//        assertEquals(true, articleResps.get(0).getArticles().get(0).getIsLike());
//    }
//
//    @Test
//    @Order(4)
//    @DisplayName("게시글 수정 테스트")
//    void updateArticle(@Autowired FileUtil fileUtil, @Autowired ArticleRepository articleRepository) throws IOException {
//        //수정할 사진
//        String path = "test.png";
//        String contentType = "image/png";
//        String dirName = "test";
//        MockMultipartFile file = new MockMultipartFile("test", path, contentType, "test".getBytes());
//
//        String urlPath = fileUtil.upload(file, dirName);
//
//        //6번 게시물 내용만 수정
//        ArticleUpdateParam firstParam = new ArticleUpdateParam(userList.get(0).getUserId(), articleList.get(5).getArticleId(), "update test");
//        articleService.updateArticle(firstParam);
//
//        Article article = articleRepository.findById(6L).get();
//        assertEquals("update test", article.getContent());
//        assertEquals("서울 관악구 1번 게시물 사진", article.getImage());
//
//
//    }
//
//    @Test
//    @Order(5)
//    @DisplayName("상세 게시물 보기 테스트")
//    void selectArticle(@Autowired ArticleRepository articleRepository) {
//        //1번 유저가 3번 게시글 보기 => 좋아요 안누름
//        ArticleDto articleDto = articleService.selectArticle(userList.get(0).getUserId(), articleList.get(2).getArticleId());
//        Article article = articleRepository.findById(articleList.get(2).getArticleId()).get();
//        assertEquals(false, articleDto.getIsLike());
//        assertEquals(article.getImage(), articleDto.getImage());
//        assertEquals(article.getContent(), articleDto.getContent());
//    }
//
//    @Test
//    @Order(6)
//    @DisplayName("게시물 삭제 테스트")
//    void deleteArticle(@Autowired ArticleRepository articleRepository) {
//        //3번이 쓴 3번 게시물 삭제
//        articleService.deleteArticle(userList.get(2).getUserId(), articleList.get(2).getArticleId());
//        List<Article> articles = articleRepository.findAll();
//        assertEquals(14, articles.size());
//
//        //2번이 5번이 쓴 게시물 삭제하려고 할때
//        boolean check = articleService.deleteArticle(userList.get(1).getUserId(), articleList.get(14).getArticleId());
//        assertFalse(check);
//
//    }
//
//}
//
//
