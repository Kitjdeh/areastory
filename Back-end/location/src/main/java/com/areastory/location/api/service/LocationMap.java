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
        List<LocationResp> locations = articleRepository.getDongeupmyeon();
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
        locations = articleRepository.getSigungu();
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

        locations = articleRepository.getDosi();
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

//        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//        System.out.println(map.get(new LocationDto("경기도", "수원시 장안구", "율전동")));
//        System.out.println(map.get(new LocationDto("충청북도", "진천군", "초평면")));
//        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        System.out.println(map.size());
        map.forEach((k, v) -> System.out.println((v.toString())));
        System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }
}
