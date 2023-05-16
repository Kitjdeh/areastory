package com.areastory.location.api.service.impl;

import com.areastory.location.api.service.LocationMap;
import com.areastory.location.api.service.LocationService;
import com.areastory.location.db.entity.Article;
import com.areastory.location.db.repository.ArticleRepository;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LocationServiceImpl implements LocationService {
    private final LocationMap locationMap;
    private final ArticleRepository articleRepository;


    @Override
    public List<LocationResp> getMapImages(List<LocationDto> locationList) {
        return locationList.stream().map(o1 -> locationMap.getMap().get(new LocationDto(o1.getDosi(), o1.getSigungu(), o1.getDongeupmyeon()))).collect(Collectors.toList());
    }

    @Override
    public List<LocationResp> getUserMapImages(Long userId, List<LocationDto> locationList) {
        LocationDto locationDto = locationList.get(0);
        if (locationDto.getDongeupmyeon() != null) {
            System.out.println("디버깅 1");
            return getDongLocation(locationList, userId);
        } else if (locationDto.getSigungu() != null) {
            return getSigunguLocation(locationList, userId);
        } else {
            return getDosiLocation(locationList, userId);
        }

    }

    private List<LocationResp> getDongLocation(List<LocationDto> locationList, Long userId) {
        if (locationList.size() == 0) {
            return null;
        }
        List<LocationResp> resps = new ArrayList<>();
        for (LocationDto locationDto : locationList) {
            Article article = articleRepository.getDong(locationDto, userId);
            resps.add(toDongResp(article));
        }

        return resps;
    }

    private LocationResp toDongResp(Article article) {
        if (article == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(article.getDosi())
                .sigungu(article.getSigungu())
                .dongeupmyeon(article.getDongeupmyeon())
                .likeCount(article.getDailyLikeCount())
                .image(article.getImage())
                .articleId(article.getArticleId())
                .build();
    }

    private List<LocationResp> getSigunguLocation(List<LocationDto> locationList, Long userId) {
        if (locationList.size() == 0) {
            return null;
        }
        List<LocationResp> resps = new ArrayList<>();
        for (LocationDto locationDto : locationList) {
            Article article = articleRepository.getSigungu(locationDto, userId);
            resps.add(toSigunguResp(article));
        }

        return resps;
    }

    private LocationResp toSigunguResp(Article article) {
        if (article == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(article.getDosi())
                .sigungu(article.getSigungu())
                .likeCount(article.getDailyLikeCount())
                .image(article.getImage())
                .articleId(article.getArticleId())
                .build();
    }

    private List<LocationResp> getDosiLocation(List<LocationDto> locationList, Long userId) {
        if (locationList.size() == 0) {
            return null;
        }
        List<LocationResp> resps = new ArrayList<>();
        for (LocationDto locationDto : locationList) {
            Article article = articleRepository.getDosi(locationDto, userId);
            resps.add(toDosiResp(article));
        }

        return resps;
    }

    private LocationResp toDosiResp(Article article) {
        if (article == null) {
            return null;
        }
        return LocationResp.builder()
                .dosi(article.getDosi())
                .likeCount(article.getDailyLikeCount())
                .image(article.getImage())
                .articleId(article.getArticleId())
                .build();
    }

}
