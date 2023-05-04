package com.areastory.location.db.entity;

import com.areastory.location.dto.common.LocationDto;
import lombok.Getter;

@Getter
public class ArticleSub extends LocationDto {
    private final Long dailyLikeCount;

    public ArticleSub(String dosi, String sigungu, String dongeupmyeon, Long dailyLikeCount) {
        super(dosi, sigungu, dongeupmyeon);
        this.dailyLikeCount = dailyLikeCount;
    }
}
