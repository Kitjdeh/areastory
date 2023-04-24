package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.CommentService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.Comment;
import com.areastory.article.db.entity.CommentLike;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.CommentLikeRepository;
import com.areastory.article.db.repository.CommentRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.CommentDeleteDto;
import com.areastory.article.dto.common.CommentUpdateDto;
import com.areastory.article.dto.request.CommentReq;
import com.areastory.article.dto.request.CommentWriteReq;
import com.areastory.article.dto.response.CommentResp;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Configuration
@DisplayName("댓글 테스트")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class) // @Order 에 의해서 실행 순서 결정
public class CommentServiceImplTest {

    static List<User> userList;
    static List<Article> articleList;
    static List<Comment> commentList;
    @Autowired
    CommentService commentService;

    @BeforeAll
    static void setup(@Autowired UserRepository userRepository,
                      @Autowired ArticleRepository articleRepository) {
        //user 정보 세팅
        userList = userRepository.findAll();
        //게시글 저장
        articleList = articleRepository.findAll();
    }


    /*
    comment 작성 테스트
     */
    @Test
    @Order(1)
    @DisplayName("댓글 작성 테스트")
    void addComment(@Autowired CommentRepository commentRepository, @Autowired ArticleRepository articleRepository) {
        List<CommentWriteReq> commentReqs = new ArrayList<>();

        commentReqs.add(new CommentWriteReq(userList.get(0).getUserId(), articleList.get(0).getArticleId(), "1번 유저가 1번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(1).getUserId(), articleList.get(0).getArticleId(), "2번 유저가 1번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(2).getUserId(), articleList.get(0).getArticleId(), "3번 유저가 1번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(3).getUserId(), articleList.get(0).getArticleId(), "4번 유저가 1번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(0).getUserId(), articleList.get(1).getArticleId(), "1번 유저가 2번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(1).getUserId(), articleList.get(1).getArticleId(), "2번 유저가 2번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(2).getUserId(), articleList.get(1).getArticleId(), "3번 유저가 2번 게시물에 댓글 달았음"));
        commentReqs.add(new CommentWriteReq(userList.get(3).getUserId(), articleList.get(1).getArticleId(), "4번 유저가 2번 게시물에 댓글 달았음"));

        for (CommentWriteReq commentWriteReq : commentReqs) {
            commentService.addComment(commentWriteReq);
        }
        //댓글 테이블 확인
        commentList = commentRepository.findAll();
        assertEquals(8, commentList.size());

        //게시물에 commentCount가 제대로 되어있는지 확인
        Article articleOne = articleRepository.findById(1L).get();
        assertEquals(4, articleOne.getCommentCount());

        Article articleTwo = articleRepository.findById(2L).get();
        assertEquals(4, articleOne.getCommentCount());
    }

    /*
    like를 눌렀을 때 테스트
    like 중복 값 안들어가는 것 확인,
    like 눌렀을 때 article 의 likeCount 값 변경 되는지 확인
     */
    @Test
    @Order(2)
    @DisplayName("댓글 좋아요 테스트")
    void addLike(@Autowired CommentLikeRepository commentLikeRepository, @Autowired CommentRepository commentRepository) {
        List<CommentLike> commentLikeList = new ArrayList<>();
        //3번 댓글에 좋아요 5개
        commentLikeList.add(new CommentLike(userList.get(0).getUserId(), commentList.get(2).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(1).getUserId(), commentList.get(2).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(2).getUserId(), commentList.get(2).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(3).getUserId(), commentList.get(2).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(4).getUserId(), commentList.get(2).getCommentId()));

        //2번 댓글에 좋아요 3개 => 중복 체크
        commentLikeList.add(new CommentLike(userList.get(1).getUserId(), commentList.get(1).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(1).getUserId(), commentList.get(1).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(3).getUserId(), commentList.get(1).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(4).getUserId(), commentList.get(1).getCommentId()));

        //1번 댓글에 좋아요 3개
        commentLikeList.add(new CommentLike(userList.get(1).getUserId(), commentList.get(0).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(2).getUserId(), commentList.get(0).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(3).getUserId(), commentList.get(0).getCommentId()));

        //4번 댓글에 좋아요 2개
        commentLikeList.add(new CommentLike(userList.get(2).getUserId(), commentList.get(3).getCommentId()));
        commentLikeList.add(new CommentLike(userList.get(3).getUserId(), commentList.get(3).getCommentId()));

        for (CommentLike commentLike : commentLikeList) {
            commentService.addCommentLike(commentLike.getUserId(), commentLike.getCommentId());
        }

        List<CommentLike> checkCommentLikes = commentLikeRepository.findAll();
        List<Comment> comments = commentRepository.findAll();

        assertEquals(13, checkCommentLikes.size());
        assertEquals(3, comments.get(0).getLikeCount());
        assertEquals(3, comments.get(1).getLikeCount());
        assertEquals(5, comments.get(2).getLikeCount());
        assertEquals(2, comments.get(3).getLikeCount());
    }


    @Test
    @Order(3)
    @DisplayName("해당 게시물의 모든 댓글 불러오기 테스트")
    void selectAllComment() {
        List<CommentReq> commentReqs = new ArrayList<>();
        List<CommentResp> commentResps = new ArrayList<>();

        commentReqs.add(new CommentReq(userList.get(0).getUserId(), articleList.get(0).getArticleId()));
        commentReqs.add(new CommentReq(userList.get(2).getUserId(), articleList.get(0).getArticleId()));

        Pageable pageable = PageRequest.of(0, 15, Sort.Direction.DESC, "createdAt");

        for (CommentReq commentReq : commentReqs) {
            commentResps.add(commentService.selectAllComment(commentReq, pageable));
        }

        //1번 유저가 첫번째 게시글의 댓글 불러오기 확인
        assertEquals(4, commentResps.get(0).getComments().size());
        assertEquals(2, commentResps.get(0).getComments().get(0).getLikeCount());
        assertEquals(5, commentResps.get(0).getComments().get(1).getLikeCount());
        assertEquals(3, commentResps.get(0).getComments().get(2).getLikeCount());
        assertEquals(3, commentResps.get(0).getComments().get(3).getLikeCount());
        assertEquals(false, commentResps.get(0).getComments().get(0).getIsLike());
        //3번 유저가 첫번째 게시글의 댓글 불러오기
        assertEquals(4, commentResps.get(1).getComments().size());
        assertEquals(2, commentResps.get(1).getComments().get(0).getLikeCount());
        assertEquals(5, commentResps.get(1).getComments().get(1).getLikeCount());
        assertEquals(3, commentResps.get(1).getComments().get(2).getLikeCount());
        assertEquals(3, commentResps.get(1).getComments().get(3).getLikeCount());
        assertEquals(true, commentResps.get(1).getComments().get(0).getIsLike());
    }


    /*
    like 취소 했을 때 테스트
    like 취소 시 값이 변경 되는지 테스트
     */
    @Test
    @Order(4)
    @DisplayName("댓글 좋아요 취소 테스트")
    void deleteLike(@Autowired CommentLikeRepository commentLikeRepository, @Autowired CommentRepository commentRepository) {
        List<CommentLike> commentLikeDeletes = new ArrayList<>();

        //3번 유저가 단 댓글 좋아요 삭제 (5개 => 3개)
        commentLikeDeletes.add(new CommentLike(userList.get(2).getUserId(), commentList.get(0).getCommentId()));
        commentLikeDeletes.add(new CommentLike(userList.get(2).getUserId(), commentList.get(2).getCommentId()));
        //좋아요를 안누른 댓글 좋아요 취소해보기(1번 사람이 1번 댓글)
        assertFalse(commentService.deleteCommentLike(userList.get(0).getUserId(), commentList.get(0).getCommentId()));
        //1번 댓글 2번 연속 삭제 (똑같은 사람이 두번 눌렀을 때)
        commentLikeDeletes.add(new CommentLike(userList.get(3).getUserId(), commentList.get(0).getCommentId()));
        commentLikeDeletes.add(new CommentLike(userList.get(3).getUserId(), commentList.get(0).getCommentId()));

        for (CommentLike commentLikeDelete : commentLikeDeletes) {
            commentService.deleteCommentLike(commentLikeDelete.getUserId(), commentLikeDelete.getCommentId());
        }
        List<CommentLike> checkCommentLike = commentLikeRepository.findAll();
        List<Comment> comments = commentRepository.findAll();

        assertEquals(10, checkCommentLike.size());
        assertEquals(1, comments.get(0).getLikeCount());
        assertEquals(3, comments.get(1).getLikeCount());
        assertEquals(4, comments.get(2).getLikeCount());
        assertEquals(2, comments.get(3).getLikeCount());
    }

    @Test
    @Order(5)
    @DisplayName("댓글 수정 테스트")
    void updateArticle(@Autowired CommentRepository commentRepository) {

        //commentId 1번 수정
        CommentUpdateDto commentUpdateDto = new CommentUpdateDto(userList.get(0).getUserId(), commentList.get(0).getCommentId(), "댓글 수정 test");
        boolean check = commentService.updateComment(commentUpdateDto);
        assertTrue(check);
        assertEquals("댓글 수정 test", commentRepository.findById(1L).get().getContent());

        //수정 권한이 없는 사람이 1번 게시글 수정
        commentUpdateDto = new CommentUpdateDto(userList.get(0).getUserId(), commentList.get(1).getCommentId(), "댓글 수정 test");
        boolean check2 = commentService.updateComment(commentUpdateDto);
        assertFalse(check2);
    }

    @Test
    @Order(6)
    @DisplayName("댓글 삭제 테스트")
    void deleteArticle(@Autowired CommentRepository commentRepository) {
        //1번이 자기가 쓴 commentId 1번 삭제
        commentService.deleteComment(new CommentDeleteDto(userList.get(0).getUserId(), commentList.get(0).getCommentId(), articleList.get(0).getArticleId()));
        List<Comment> comments = commentRepository.findAll();
        assertEquals(7, comments.size());

        //1번이 3번이 쓴 게시물 삭제하려고 할때
        boolean check = commentService.deleteComment(new CommentDeleteDto(userList.get(0).getUserId(), commentList.get(2).getCommentId(), articleList.get(0).getArticleId()));
        assertFalse(check);

    }

}
