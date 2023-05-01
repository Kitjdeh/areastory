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
    public LocationResp(String doName, String si, String gun, String gu, String dong, String eup, String myeon, String image, Long articleId) {
        this.locationDto = new LocationDto(doName, si, gun, gu, dong, eup, myeon);
        this.image = image;
        this.articleId = articleId;
    }
}
