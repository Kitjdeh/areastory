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
                .image(articleKafkaDto.getImage())
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
        //증가로직
        //dosi, sigungu, dongeupmyeon 1위 확인
        LocationDto dongeupmyeonDto = new LocationDto(articleKafkaDto.getDosi(), articleKafkaDto.getSigungu(), articleKafkaDto.getDongeupmyeon());
        checkLikeCount(dongeupmyeonDto, articleKafkaDto);

        //dosi, sigungu 1위 확인
        LocationDto sigunguDto = new LocationDto(articleKafkaDto.getDosi(), articleKafkaDto.getSigungu());
        checkLikeCount(sigunguDto, articleKafkaDto);

        //dosi 1위 확인
        LocationDto dosiDto = new LocationDto(articleKafkaDto.getDosi());
        checkLikeCount(dosiDto, articleKafkaDto);

        Article article = articleRepository.findById(articleKafkaDto.getArticleId()).orElseThrow();
        article.setDailyLikeCount(articleKafkaDto.getDailyLikeCount());
        article.setPublicYn(articleKafkaDto.getPublicYn());


        //감소로직
//        Long dailyLikeCount = articleKafkaDto.getDailyLikeCount();
//        articleRepository.getDailyLikeCount(dailyLikeCount);


//        LocationResp locationResp = locationMap.getMap().get(new LocationDto(articleKafkaDto.getDosi(), articleKafkaDto.getSigungu(), articleKafkaDto.getDongeupmyeon()));
        //증가 로직
//        if (locationResp == null || locationResp.getLikeCount() < articleKafkaDto.getDailyLikeCount()) {
//            //dosi, sigungu, dongeupmyeon 단위 바꾸기
//            locationMap.getMap().put(dongeupmyeonDto, new LocationResp(
//                    articleKafkaDto.getArticleId(),
//                    articleKafkaDto.getImage(),
//                    articleKafkaDto.getDailyLikeCount(),
//                    dongeupmyeonDto
//            ));
//        }

//        }
    }

    @Override
    @Transactional
    public void deleteArticle(ArticleKafkaDto articleKafkaDto) {
        articleRepository.deleteById(articleKafkaDto.getArticleId());
    }

    private void checkLikeCount(LocationDto locationDto, ArticleKafkaDto articleKafkaDto) {
        LocationResp locationResp = locationMap.getMap().get(locationDto);
        //증가 로직
        if (locationResp == null || locationResp.getLikeCount() < articleKafkaDto.getDailyLikeCount()) {
            locationMap.getMap().put(locationDto, new LocationResp(
                    articleKafkaDto.getArticleId(),
                    articleKafkaDto.getImage(),
                    articleKafkaDto.getDailyLikeCount(),
                    locationDto
            ));
        }
    }
}
