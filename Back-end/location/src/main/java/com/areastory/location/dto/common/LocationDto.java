package com.areastory.location.dto.common;

import lombok.Builder;
import lombok.Getter;

import java.util.Objects;

@Getter
public class LocationDto {
    private String dosi;
    private String sigungu;
    private String dongeupmyeon;

    @Builder
    public LocationDto(String dosi, String sigungu, String dongeupmyeon) {
        this.dosi = dosi;
        this.sigungu = sigungu;
        this.dongeupmyeon = dongeupmyeon;
    }

    @Builder
    public LocationDto(String dosi, String sigungu) {
        this.dosi = dosi;
        this.sigungu = sigungu;
    }

    @Builder
    public LocationDto(String dosi) {
        this.dosi = dosi;
    }

    public LocationDto() {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof LocationDto)) return false;
        LocationDto that = (LocationDto) o;
        return dosi.equals(that.dosi) && Objects.equals(sigungu, that.sigungu) && Objects.equals(dongeupmyeon, that.dongeupmyeon);
    }

    @Override
    public int hashCode() {
        return Objects.hash(dosi, sigungu, dongeupmyeon);
    }
}
