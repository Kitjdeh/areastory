package com.areastory.location.api.controller;

import com.areastory.location.dto.common.LocationDto;
import com.areastory.location.dto.response.LocationResp;
import com.areastory.location.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class LocationController {
    private final LocationService locationService;

    @GetMapping("/map")
    public ResponseEntity<List<LocationResp>> getMap(@RequestBody List<LocationDto> locationList) {
        try {
            return ResponseEntity.ok(locationService.getMapImages(locationList));
        } catch (Exception e) {
            System.out.println("뭔가 잘못됨 ㅋㅋ");
            return ResponseEntity.noContent().build();
        }
    }

    @GetMapping("/map/{userId}")
    public ResponseEntity<List<LocationResp>> getUserMap(@PathVariable Long userId, @RequestBody List<LocationDto> locationList) {
        try {
            return ResponseEntity.ok(locationService.getUserMapImages(userId, locationList));
        } catch (Exception e) {
            System.out.println("뭔가 잘못됨 ㅋㅋ");
            return ResponseEntity.noContent().build();
        }
    }
}
