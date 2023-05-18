package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.ArticleLike;
import com.areastory.article.db.entity.ArticleLikePK;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.ArticleLikeRepository;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import com.areastory.article.dto.response.ArticleResp;
import com.areastory.article.dto.response.LikeResp;
import com.areastory.article.exception.CustomException;
import com.areastory.article.exception.ErrorCode;
import com.areastory.article.kafka.ArticleProducer;
import com.areastory.article.kafka.KafkaProperties;
import com.areastory.article.kafka.NotificationProducer;
import com.areastory.article.util.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository;
    private final ArticleLikeRepository articleLikeRepository;
    private final UserRepository userRepository;
    private final FileUtil fileUtil;
    private final NotificationProducer notificationProducer;
    private final ArticleProducer articleProducer;

    @Transactional
    @Override
    public void addArticle(ArticleWriteReq articleWriteReq, MultipartFile picture) {
        User user = userRepository.findById(articleWriteReq.getUserId()).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        String imageUrl = "";
        String thumbnail = "";
        if (picture != null) {
            imageUrl = fileUtil.upload(picture, "picture");
            thumbnail = fileUtil.uploadThumbnail(picture, "thumbnail");
        }

        Article article = articleRepository.save(Article.builder()
                .user(user)
                .content(articleWriteReq.getContent())
                .image(imageUrl)
                .thumbnail(thumbnail)
                .dailyLikeCount(0L)
                .commentCount(0L)
                .publicYn(articleWriteReq.getPublicYn())
                .dosi(articleWriteReq.getDosi())
                .sigungu(articleWriteReq.getSigungu())
                .dongeupmyeon(articleWriteReq.getDongeupmyeon())
                .build());

        articleProducer.send(article, KafkaProperties.INSERT);
    }

    @Override
    public ArticleResp selectAllArticle(ArticleReq articleReq, Pageable pageable) {
        Page<ArticleDto> articles = articleRepository.findAll(articleReq, pageable);
        return ArticleResp.builder()
                .articles(articles.getContent())
                .pageSize(articles.getPageable().getPageSize())
                .totalPageNumber(articles.getTotalPages())
                .totalCount(articles.getTotalElements())
                .pageNumber(articles.getPageable().getPageNumber() + 1)
                .nextPage(articles.hasNext())
                .previousPage(articles.hasPrevious())
                .build();
    }

    @Override
    public ArticleDto selectArticle(Long userId, Long articleId) {
        return articleRepository.findById(userId, articleId);
    }

    @Transactional
    @Override
    public void updateArticle(ArticleUpdateParam param) {
        Article article = articleRepository.findById(param.getArticleId()).orElseThrow(() -> new CustomException(ErrorCode.ARTICLE_NOT_FOUND));

        //게시글 수정 권한이 없을 때
        if (!Objects.equals(article.getUser().getUserId(), param.getUserId())) {
            throw new CustomException(ErrorCode.UNAUTHORIZED_REQUEST);
        }

        if (StringUtils.hasText(param.getContent())) {
            article.updateContent(param.getContent());
        }

        //현재 article의 상태와 update될 공개여부의 상태가 다르면 변경
        if (article.getPublicYn() != param.getPublicYn()) {
            article.updatePublicYn(param.getPublicYn());
        }

        articleProducer.send(article, KafkaProperties.UPDATE);
    }

    @Transactional
    @Override
    public void deleteArticle(Long userId, Long articleId) {
        Article article = articleRepository.findById(articleId).orElseThrow(() -> new CustomException(ErrorCode.ARTICLE_NOT_FOUND));
        if (!Objects.equals(article.getUser().getUserId(), userId)) {
            throw new CustomException(ErrorCode.UNAUTHORIZED_REQUEST);
        }
        fileUtil.deleteFile(article.getImage());
        articleRepository.delete(article);
        articleProducer.send(article, KafkaProperties.DELETE);
    }

    @Transactional
    @Override
    public void addArticleLike(Long userId, Long articleId) {
        if (articleLikeRepository.existsById(new ArticleLikePK(userId, articleId))) {
            throw new CustomException(ErrorCode.DUPLICATE_RESOURCE);
        }
        Article article = articleRepository.findById(articleId).orElseThrow(() -> new CustomException(ErrorCode.ARTICLE_NOT_FOUND));
        User user = userRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));
        ArticleLike articleLike = articleLikeRepository.save(new ArticleLike(user, article));
        article.addTotalLikeCount();
        notificationProducer.send(articleLike);
        articleProducer.send(article, KafkaProperties.UPDATE);
    }

    @Transactional
    @Override
    public void deleteArticleLike(Long userId, Long articleId) {
        ArticleLikePK articleLikePK = new ArticleLikePK(userId, articleId);
        Optional<ArticleLike> optionalArticleLike = articleLikeRepository.findById(articleLikePK);
        if (optionalArticleLike.isEmpty()) {
            throw new CustomException(ErrorCode.LIKE_NOT_FOUND);
        }
        ArticleLike articleLike = optionalArticleLike.get();

        Article article = articleRepository.findById(articleId).orElseThrow();
        // 하루 전이라면 daily like count 도 감소시켜야 함
        LocalDateTime yesterday = LocalDateTime.now().minusDays(1).withHour(0).withMinute(0).withSecond(0);
        if (yesterday.isBefore(articleLike.getCreatedAt())) {
            article.removeDailyLikeCount();
        }
        article.removeTotalLikeCount();
        articleLikeRepository.deleteById(articleLikePK);
        articleProducer.send(article, KafkaProperties.UPDATE);
    }

    @Override
    public LikeResp selectAllLikeList(Long userId, Long articleId, Pageable pageable) {
        Page<UserDto> likes = articleRepository.findAllLike(userId, articleId, pageable);
        return LikeResp.builder()
                .users(likes.getContent())
                .pageSize(likes.getPageable().getPageSize())
                .totalPageNumber(likes.getTotalPages())
                .totalCount(likes.getTotalElements())
                .pageNumber(likes.getPageable().getPageNumber() + 1)
                .nextPage(likes.hasNext())
                .previousPage(likes.hasPrevious())
                .build();
    }

    @Override
    public ArticleResp selectMyLikeList(Long userId, Pageable pageable) {
        Page<ArticleDto> likes = articleRepository.findMyLikeList(userId, pageable);
        return ArticleResp.builder()
                .articles(likes.getContent())
                .pageSize(likes.getPageable().getPageSize())
                .totalPageNumber(likes.getTotalPages())
                .totalCount(likes.getTotalElements())
                .pageNumber(likes.getPageable().getPageNumber() + 1)
                .nextPage(likes.hasNext())
                .previousPage(likes.hasPrevious())
                .build();
    }

    @Override
    public ArticleResp selectAllFollowArticle(Long userId, Pageable pageable) {
        Page<ArticleDto> followArticles = articleRepository.findAllFollowArticleList(userId, pageable);
        return ArticleResp.builder()
                .articles(followArticles.getContent())
                .pageSize(followArticles.getPageable().getPageSize())
                .totalPageNumber(followArticles.getTotalPages())
                .totalCount(followArticles.getTotalElements())
                .pageNumber(followArticles.getPageable().getPageNumber() + 1)
                .nextPage(followArticles.hasNext())
                .previousPage(followArticles.hasPrevious())
                .build();
    }
}
