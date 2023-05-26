package com.areastory.location.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Index;
import javax.persistence.MappedSuperclass;
import java.util.Objects;

@Getter
@MappedSuperclass
@NoArgsConstructor
public class Location {
    @Column(length = 10)
    private String dosi;
    @Column(length = 10)
    private String sigungu;
    @Column(length = 10)
    private String dongeupmyeon;

    @Builder
    public Location(String dosi, String sigungu, String dongeupmyeon) {
        this.dosi = dosi;
        this.sigungu = sigungu;
        this.dongeupmyeon = dongeupmyeon;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Location location = (Location) o;
        return Objects.equals(dosi, location.dosi) && Objects.equals(sigungu, location.sigungu) && Objects.equals(dongeupmyeon, location.dongeupmyeon);
    }

    @Override
    public int hashCode() {
        return Objects.hash(dosi, sigungu, dongeupmyeon);
    }

    public Location(Location location) {
        this.dosi = location.dosi;
        this.sigungu = location.sigungu;
        this.dongeupmyeon = location.dongeupmyeon;
    }

}
