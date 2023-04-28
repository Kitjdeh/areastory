package com.areastory.user.controller;

import com.areastory.user.dto.response.NotificationResp;
import com.areastory.user.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping("/notifications")
    public ResponseEntity<NotificationResp> selectAllNotification(Long userId,
                                                                  @PageableDefault(sort = {"notificationId"}, direction = Sort.Direction.DESC, size = 15) Pageable pageable) {
        NotificationResp notificationResp = notificationService.selectAllNotifications(userId, pageable);
        return ResponseEntity.ok(notificationResp);
    }

    @PatchMapping("/notifications/{notificationId}")
    public ResponseEntity<NotificationResp> checkNotification(@PathVariable Long notificationId) {
        notificationService.checkNotification(notificationId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/notifications/{notificationId}")
    public ResponseEntity<NotificationResp> deleteNotification(Long userId, @PathVariable Long notificationId) {
        notificationService.deleteNotification(userId, notificationId);
        return ResponseEntity.ok().build();
    }
}
