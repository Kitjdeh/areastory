package com.areastory.location.api.service.impl;

import com.areastory.location.db.repository.ArticleRepository;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import com.areastory.location.api.service.LocationService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LocationServiceImpl implements LocationService {
    private final ArticleRepository articleRepository;

    public LocationServiceImpl(ArticleRepository articleRepository) {
        this.articleRepository = articleRepository;
    }

    @Override
    public List<LocationResp> getMapImages(List<LocationDto> locationList) throws Exception {
        List<LocationResp> articleList = articleRepository.getArticleList(locationList);
        return removeDistinct(locationList, articleList);
    }

    @Override
    public List<LocationResp> getUserMapImages(Long userId, List<LocationDto> locationList) throws Exception {
        List<LocationResp> articleList = articleRepository.getUserArticleList(userId, locationList);
        return removeDistinct(locationList, articleList);
    }

    private List<LocationResp> removeDistinct(List<LocationDto> locationList, List<LocationResp> articleList) throws Exception {
        // locationDto : 1,2,3
        // articleList : 1, 1, 2, 2, 3, 3, 3
        Map<LocationDto, LocationResp> articleMap = new HashMap<>();
        LocationResp dummy = new LocationResp();
        locationList.forEach(locationDto -> articleMap.put(locationDto, dummy));
        for (LocationResp locationResp : articleList) {
            if (!articleMap.containsKey(locationResp.getLocationDto()))
                throw new Exception("뭔가 잘못됨");
            if (articleMap.get(locationResp.getLocationDto()) == dummy)
                articleMap.put(locationResp.getLocationDto(), locationResp);
        }
        for (LocationDto locationDto : locationList) {
            LocationResp locationResp = articleMap.get(locationDto);
            articleMap.put(locationDto, LocationResp.builder()
                    .dosi(locationDto.getDosi())
                    .sigungu(locationDto.getSigungu())
                    .dongeupmyeon(locationDto.getDongeupmyeon())
                    .image(locationResp.getImage())
                    .articleId(locationResp.getArticleId())
                    .build());
        }
        return new ArrayList<>(articleMap.values());
    }
}
