package com.areastory.location.db.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Index;
import javax.persistence.MappedSuperclass;

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



    public Location(Location location) {
        this.dosi = location.dosi;
        this.sigungu = location.sigungu;
        this.dongeupmyeon = location.dongeupmyeon;
    }

}
