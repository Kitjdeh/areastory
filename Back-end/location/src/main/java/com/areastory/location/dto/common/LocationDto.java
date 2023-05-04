package com.areastory.location.dto.common;

import lombok.Builder;
import lombok.Getter;

import javax.persistence.Column;

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



    @Override
    public int hashCode() {
        return 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof LocationDto)) {
            return false;
        }
        LocationDto other = (LocationDto) obj;
        return (other.dosi == null || other.dosi.equals(this.dosi)) &&
                (other.sigungu == null || other.sigungu.equals(this.sigungu)) &&
                (other.dongeupmyeon == null || other.dongeupmyeon.equals(this.dongeupmyeon));
    }
}
