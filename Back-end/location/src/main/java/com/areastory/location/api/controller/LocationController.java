package com.areastory.location.api.controller;

import com.areastory.location.api.service.LocationService;
import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
@Slf4j
public class LocationController {
    private final LocationService locationService;

    @PostMapping("/map")
    public ResponseEntity<List<LocationResp>> getMap(@RequestBody List<LocationDto> locationList) {
        try {
            List<LocationResp> resps = locationService.getMapImages(locationList);
            return ResponseEntity.ok(resps);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("뭔가 잘못됨 ㅋㅋ");
            return ResponseEntity.noContent().build();
        }
    }

    @PostMapping("/map/{userId}")
    public ResponseEntity<List<LocationResp>> getUserMap(@PathVariable Long userId, @RequestBody List<LocationDto> locationList) {
        try {
            System.out.println("userId: " + userId);
            return ResponseEntity.ok(locationService.getUserMapImages(userId, locationList));
        } catch (Exception e) {
            System.out.println("뭔가 잘못됨 ㅋㅋ");
            return ResponseEntity.noContent().build();
        }
    }
}
