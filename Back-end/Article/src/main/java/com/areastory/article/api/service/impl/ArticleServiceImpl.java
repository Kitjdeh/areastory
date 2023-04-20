package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.db.entity.Article;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.ArticleRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.ArticleTest;
import com.areastory.article.dto.request.ArticleReq;
import com.areastory.article.dto.request.ArticleUpdateParam;
import com.areastory.article.dto.request.ArticleWriteReq;
import com.areastory.article.util.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository;
    private final UserRepository userRepository;
    private final FileUtil fileUtil;

    @Override
    public void addArticle(Long userId, ArticleWriteReq articleWriteReq, MultipartFile picture) throws IOException {
        User user = userRepository.findById(userId).orElseThrow();

        String imageUrl = "";
        if (picture != null) {
            imageUrl = fileUtil.upload(picture, "picture");
        }

        articleRepository.save(Article.builder()
                .user(user)
                .content(articleWriteReq.getContent())
                .image(imageUrl)
                .doName(articleWriteReq.getDoName())
                .si(articleWriteReq.getSi())
                .gun(articleWriteReq.getGun())
                .gu(articleWriteReq.getGu())
                .dong(articleWriteReq.getDong())
                .eup(articleWriteReq.getEup())
                .myeon(articleWriteReq.getMyeon())
                .build());
    }

    @Override
    public List<ArticleTest> selectAllArticle(ArticleReq articleReq, Pageable pageable) {
//        Page<ArticleDto> articles = articleRepository.findAll(articleReq, pageable);
        List<ArticleTest> articleInfo = articleRepository.findAll(articleReq, pageable);

//        return ArticleResp.builder()
//                .articles(articles.getContent())
//                .pageSize(articles.getPageable().getPageSize())
//                .totalPageNumber(articles.getTotalPages())
//                .totalCount(articles.getTotalElements())
//                .build();
        return articleInfo;
    }

    @Override
    public ArticleDto selectArticle(Long userId, Long articleId) {
        return articleRepository.findById(userId, articleId);
    }

    @Override
    public boolean updateArticle(Long userId, ArticleUpdateParam param, MultipartFile picture) throws IOException {
        Article article = articleRepository.findById(param.getArticleId()).get();

        //게시글 수정 권한이 없을 때
        if (!Objects.equals(article.getUser().getUserId(), userId)) {
            return false;
        }

        if (StringUtils.hasText(param.getContent())) {
            article.updateContent(param.getContent());
        }

        if (picture != null) {
            fileUtil.deleteFile(article.getImage());
            String url = fileUtil.upload(picture, "picture");
            article.updateImage(url);
        }
        return true;
    }

    @Override
    public boolean deleteArticle(Long userId, Long articleId) {
        Article article = articleRepository.findById(articleId).get();
        if (!Objects.equals(article.getUser().getUserId(), userId)) {
            return false;
        }
        articleRepository.delete(article);
        return true;
    }
}
