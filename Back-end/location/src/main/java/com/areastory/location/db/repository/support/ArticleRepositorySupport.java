package com.areastory.location.db.repository.support;


import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;

import java.util.List;

public interface ArticleRepositorySupport {


    LocationResp getDailyLikeCountData(String type, Long articleId, LocationDto locationDto, Long dailyLikeCount);

    List<LocationResp> getInitDosi();

    List<LocationResp> getInitSigungu();

    List<LocationResp> getInitDongeupmyeon();

}
