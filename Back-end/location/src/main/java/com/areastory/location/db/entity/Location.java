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
    @Column(name = "do", length = 7)
    private String doName;
    @Column(length = 10)
    private String si;
    @Column(length = 10)
    private String gun;
    @Column(length = 10)
    private String gu;
    @Column(length = 10)
    private String dong;
    @Column(length = 10)
    private String eup;
    @Column(length = 10)
    private String myeon;

    @Builder
    public Location(String doName, String si, String gun, String gu, String dong, String eup, String myeon) {
        this.doName = doName;
        this.si = si;
        this.gun = gun;
        this.gu = gu;
        this.dong = dong;
        this.eup = eup;
        this.myeon = myeon;
    }

    public Location(Location location) {
        this.doName = location.getDoName();
        this.si = location.getSi();
        this.gun = location.getGun();
        this.gu = location.getGu();
        this.dong = location.getDong();
        this.eup = location.getEup();
        this.myeon = location.getMyeon();
    }

}
