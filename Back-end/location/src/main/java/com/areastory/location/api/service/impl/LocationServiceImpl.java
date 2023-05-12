package com.areastory.location.api.service.impl;

import com.areastory.location.api.service.LocationMap;
import com.areastory.location.api.service.LocationService;
import com.areastory.location.db.repository.ArticleRepository;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
        return articleRepository.getUserArticleList(userId, locationList);
    }

}
