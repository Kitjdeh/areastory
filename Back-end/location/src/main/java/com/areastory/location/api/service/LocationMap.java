package com.areastory.location.api.service;

import com.areastory.location.db.repository.ArticleRepository;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class LocationMap {
    private final Map<LocationDto, LocationResp> map;
    private final ArticleRepository articleRepository;

    public LocationMap(ArticleRepository articleRepository) {
        map = new ConcurrentHashMap<>();
        this.articleRepository = articleRepository;
    }

    public Map<LocationDto, LocationResp> getMap() {
        return map;
    }


    @PostConstruct
    public void init() {
        //모든 지역의 article중 가장 좋아요가 높은 거를 넣어야함
        //sql로 동단위까지 groupby시킨걸 불러옴
        //dosi, sigungu, dongeupmyeon
        List<LocationResp> locations = articleRepository.getInitDongeupmyeon();
        locations.forEach(o1 -> map
                .put(LocationDto.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .sigungu(o1.getLocationDto().getSigungu())
                                .dongeupmyeon(o1.getLocationDto().getDongeupmyeon())
                                .build(),
                        LocationResp.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .sigungu(o1.getLocationDto().getSigungu())
                                .dongeupmyeon(o1.getLocationDto().getDongeupmyeon())
                                .image(o1.getImage())
                                .articleId(o1.getArticleId())
                                .likeCount(o1.getLikeCount())
                                .build()));

        //dosi, sigungu
        locations = articleRepository.getInitSigungu();
        locations.forEach(o1 -> map
                .put(LocationDto.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .sigungu(o1.getLocationDto().getSigungu())
                                .build(),
                        LocationResp.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .sigungu(o1.getLocationDto().getSigungu())
                                .image(o1.getImage())
                                .articleId(o1.getArticleId())
                                .likeCount(o1.getLikeCount())
                                .build()));

        locations = articleRepository.getInitDosi();
        locations.forEach(o1 -> map
                .put(LocationDto.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .build(),
                        LocationResp.builder()
                                .dosi(o1.getLocationDto().getDosi())
                                .image(o1.getImage())
                                .articleId(o1.getArticleId())
                                .likeCount(o1.getLikeCount())
                                .build()));


    }
}

