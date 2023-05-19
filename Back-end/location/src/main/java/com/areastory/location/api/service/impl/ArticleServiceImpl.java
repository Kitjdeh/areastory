package com.areastory.location.api.service.impl;

import com.areastory.location.api.service.ArticleService;
import com.areastory.location.api.service.LocationMap;
import com.areastory.location.db.entity.Article;
import com.areastory.location.db.entity.Location;
import com.areastory.location.db.repository.ArticleRepository;
import com.areastory.location.dto.common.ArticleKafkaDto;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {
    private static final String DOSI = "dosi";
    private static final String SIGUNGU = "sigungu";
    private static final String DONGEUPMYEON = "dongeupmyeon";
    private final ArticleRepository articleRepository;
    private final LocationMap locationMap;

    @Override
    @Transactional
    public void addArticle(ArticleKafkaDto articleKafkaDto) {
        Location location = Location.builder()
                .dosi(articleKafkaDto.getDosi())
                .sigungu(articleKafkaDto.getSigungu())
                .dongeupmyeon(articleKafkaDto.getDongeupmyeon())
                .build();
        Article article = Article.articleBuilder()
                .articleId(articleKafkaDto.getArticleId())
                .userId(articleKafkaDto.getUserId())
                .image(articleKafkaDto.getThumbnail())
                .dailyLikeCount(articleKafkaDto.getDailyLikeCount())
                .createdAt(articleKafkaDto.getCreatedAt())
                .location(location)
                .publicYn(articleKafkaDto.getPublicYn())
                .build();
        articleRepository.save(article);
    }

    @Override
    @Transactional
    public void updateArticle(ArticleKafkaDto articleKafkaDto) {
        //dosi, sigungu, dongeupmyeon 1위 확인
        LocationDto dongeupmyeonDto = new LocationDto(articleKafkaDto.getDosi(), articleKafkaDto.getSigungu(), articleKafkaDto.getDongeupmyeon());
        checkLikeCount(DONGEUPMYEON, dongeupmyeonDto, articleKafkaDto);

        //dosi, sigungu 1위 확인
        LocationDto sigunguDto = new LocationDto(articleKafkaDto.getDosi(), articleKafkaDto.getSigungu());
        checkLikeCount(SIGUNGU, sigunguDto, articleKafkaDto);

        //dosi 1위 확인
        LocationDto dosiDto = new LocationDto(articleKafkaDto.getDosi());
        checkLikeCount(DOSI, dosiDto, articleKafkaDto);

        Article article = articleRepository.findById(articleKafkaDto.getArticleId()).orElseThrow();
        article.setDailyLikeCount(articleKafkaDto.getDailyLikeCount());
        article.setPublicYn(articleKafkaDto.getPublicYn());
    }

    @Override
    @Transactional
    public void deleteArticle(ArticleKafkaDto articleKafkaDto) {
        articleRepository.deleteById(articleKafkaDto.getArticleId());
    }

    private void checkLikeCount(String type, LocationDto locationDto, ArticleKafkaDto articleKafkaDto) {
        Long likeCount = articleRepository.findById(articleKafkaDto.getArticleId()).get().getDailyLikeCount();
        System.out.println("likeCount: " + likeCount);
        LocationResp locationResp = locationMap.getMap().get(locationDto);
        if (articleKafkaDto.getDailyLikeCount() > likeCount) {
            System.out.println("db에 있는 값보다 더 높은 값으로 갱신되었을 때 여기 와?");
            //좋아요를 눌렀거나 메모리에 없는 데이터일 때
            if (locationResp == null || locationResp.getLikeCount() < articleKafkaDto.getDailyLikeCount()) {
                locationMap.getMap().put(locationDto, new LocationResp(
                        articleKafkaDto.getArticleId(),
                        articleKafkaDto.getThumbnail(),
                        articleKafkaDto.getDailyLikeCount(),
                        locationDto
                ));
            }
        } else {
            //좋아요 취소를 눌렀을 때
            if (locationResp != null && locationResp.getLikeCount() == articleKafkaDto.getDailyLikeCount() + 1) {
                Long dailyLikeCount = articleKafkaDto.getDailyLikeCount();
                //DB에서 dailyLikeCount 초과인 글들 가져오기
                LocationResp locationData = articleRepository.getDailyLikeCountData(type, articleKafkaDto.getArticleId(), locationDto, dailyLikeCount);
                //가져온 게시글의 PK 값이 현재 메모리에 있는 게시글의 PK 값과 다르다면 변경
                if (locationData != null) {
                    locationMap.getMap().put(locationDto, new LocationResp(
                            locationData.getArticleId(),
                            locationData.getImage(),
                            locationData.getLikeCount(),
                            locationDto));
                } else {
                    locationMap.getMap().put(locationDto, new LocationResp(
                            locationResp.getArticleId(),
                            locationResp.getImage(),
                            dailyLikeCount,
                            locationDto));
                }
            }
        }


    }
}
