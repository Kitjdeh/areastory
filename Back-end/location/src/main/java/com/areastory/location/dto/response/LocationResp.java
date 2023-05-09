package com.areastory.location.dto.response;

import com.areastory.location.dto.common.LocationDto;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@NoArgsConstructor
public class LocationResp {
    @Setter
    private LocationDto locationDto;
    private String image;
    private Long articleId;

    @Builder
    public LocationResp(String dosi, String sigungu, String dongeupmyeon, String image, Long articleId) {
        this.locationDto = new LocationDto(dosi, sigungu, dongeupmyeon);
        this.image = image;
        this.articleId = articleId;
    }
    @Builder
    public LocationResp(String dosi, String sigungu, String image, Long articleId) {
        this.locationDto = new LocationDto(dosi, sigungu);
        this.image = image;
        this.articleId = articleId;
    }
    @Builder
    public LocationResp(String dosi, String image, Long articleId) {
        this.locationDto = new LocationDto(dosi);
        this.image = image;
        this.articleId = articleId;
    }
}
