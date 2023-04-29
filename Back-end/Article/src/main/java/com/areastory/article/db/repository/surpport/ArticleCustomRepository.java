package com.areastory.article.db.repository.surpport;

import com.areastory.article.dto.common.ArticleDto;
import com.areastory.article.dto.common.ArticleRespDto;
import com.areastory.article.dto.common.UserDto;
import com.areastory.article.dto.request.ArticleReq;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Arrays;
import java.util.List;

public interface ArticleCustomRepository {
    Page<ArticleRespDto> findAll(ArticleReq articleReq, Pageable pageable);

    ArticleRespDto findById(Long userId, Long articleId);

    default ArticleRespDto toArticleRespDto(ArticleDto articleDto) {
        return ArticleRespDto.builder()
                .articleId(articleDto.getArticleId())
                .userId(articleDto.getUserId())
                .nickname(articleDto.getNickname())
                .profile(articleDto.getProfile())
                .content(articleDto.getContent())
                .image(articleDto.getImage())
                .likeCount(articleDto.getLikeCount())
                .commentCount(articleDto.getCommentCount())
                .likeYn(articleDto.getLikeYn())
                .createdAt(articleDto.getCreatedAt())
                .location(toLocation(Arrays.asList(articleDto.getDoName()
                        , articleDto.getSi(), articleDto.getGun(), articleDto.getGu()
                        , articleDto.getDong(), articleDto.getEup(), articleDto.getMyeon())))
                .build();

    }

    default String toLocation(List<String> locate) {
        StringBuilder sb = new StringBuilder();
        for (String location : locate) {
            if (location != null) {
                sb.append(location).append(" ");
            }
        }
        return sb.substring(0, sb.length() - 1);
    }

    Page<UserDto> findAllLike(Long userId, Long articleId, Pageable pageable);
}
