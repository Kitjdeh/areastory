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
//        List<LocationResp> articleList = articleRepository.getArticleList(locationList);
//        return removeDistinct(locationList, articleList);
//        LocationResp locationResp = locationMap.getMap().get(locationList.get(0));
//        System.out.println(locationResp.toString());
        return locationList.stream().map(o1 -> locationMap.getMap().get(new LocationDto(o1.getDosi(), o1.getSigungu(), o1.getDongeupmyeon()))).collect(Collectors.toList());
    }

    @Override
    public List<LocationResp> getUserMapImages(Long userId, List<LocationDto> locationList) {
        return articleRepository.getUserArticleList(userId, locationList);
    }

//    private List<LocationResp> removeDistinct(List<LocationDto> locationList, List<LocationResp> articleList) throws Exception {
//        // locationDto : 1,2,3
//        // articleList : 1, 1, 2, 2, 3, 3, 3
//        Map<LocationDto, LocationResp> articleMap = new HashMap<>();
//        LocationResp dummy = new LocationResp();
//        locationList.forEach(locationDto -> articleMap.put(locationDto, dummy));
//        for (LocationResp locationResp : articleList) {
//            if (!articleMap.containsKey(locationResp.getLocationDto()))
//                throw new Exception("뭔가 잘못됨");
//            if (articleMap.get(locationResp.getLocationDto()) == dummy)
//                articleMap.put(locationResp.getLocationDto(), locationResp);
//        }
//        for (LocationDto locationDto : locationList) {
//            LocationResp locationResp = articleMap.get(locationDto);
//            articleMap.put(locationDto, LocationResp.builder()
//                    .dosi(locationDto.getDosi())
//                    .sigungu(locationDto.getSigungu())
//                    .dongeupmyeon(locationDto.getDongeupmyeon())
//                    .image(locationResp.getImage())
//                    .articleId(locationResp.getArticleId())
//                    .build());
//        }
//        return new ArrayList<>(articleMap.values());
//    }
}
