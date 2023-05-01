package com.areastory.location.dto.common;

import lombok.Builder;
import lombok.Getter;

@Getter
public class LocationDto {
    private final String doName;
    private final String si;
    private final String gun;
    private final String gu;
    private final String dong;
    private final String eup;
    private final String myeon;

    @Builder
    public LocationDto(String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
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
        return (other.doName == null || other.doName.equals(this.doName)) &&
                (other.si == null || other.si.equals(this.si)) &&
                (other.gun == null || other.gun.equals(this.gun)) &&
                (other.gu == null || other.gu.equals(this.gu)) &&
                (other.dong == null || other.dong.equals(this.dong)) &&
                (other.eup == null || other.eup.equals(this.eup)) &&
                (other.myeon == null || other.myeon.equals(this.myeon));
    }
}
