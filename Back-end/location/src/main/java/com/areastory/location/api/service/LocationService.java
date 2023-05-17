package com.areastory.location.api.service;


import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;

import java.util.List;

public interface LocationService {


    List<LocationResp> getMapImages(List<LocationDto> locationList) throws Exception;

    List<LocationResp> getUserMapImages(Long userId, List<LocationDto> locationList) throws Exception;


}
