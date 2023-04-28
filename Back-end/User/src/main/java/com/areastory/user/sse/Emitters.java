package com.areastory.user.sse;

import com.areastory.user.dto.common.NotificationDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class Emitters {
    @Getter
    private final Map<Long, CustomEmitter> emitterMap;
    private final Map<Long, CustomEmitter> emitterWatingMap;
    private final ObjectMapper om;

    public Emitters(ObjectMapper om) {
        this.om = om;
        emitterMap = new ConcurrentHashMap<>();
        emitterWatingMap = new ConcurrentHashMap<>();
    }

    private CustomEmitter create(Long userId) {
        CustomEmitter emitter = new CustomEmitter(userId, 1000 * 60 * 60 * 24 * 30L); // 30일
        emitter.onCompletion(() -> {
            this.emitterMap.remove(userId);    // 만료되면 리스트에서 삭제
        });
        emitter.onTimeout(emitter::complete);
        try {
            emitter.send(SseEmitter.event().name("SSE CONNECTED").data("SSE CONNECTED"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return emitter;
    }

    public void addWaiting(Long userId) {
        emitterWatingMap.put(userId, create(userId));
    }

    public void add(Long userId) {
        emitterMap.put(userId, create(userId));
    }

    public void getValid(Long userId) {
        CustomEmitter emitter = emitterWatingMap.get(userId);
        emitterWatingMap.remove(userId);
        if (emitter == null) {
            emitter = create(userId);
        }
        emitterMap.put(userId, emitter);
        try {
            emitter.send(SseEmitter.event().name("validated").data("validated"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void remove(Long userId) {
        emitterMap.remove(userId);
    }

    public void send(Long userId, NotificationDto notificationDto) {
        try {
            emitterMap.get(userId).send(SseEmitter.event()
                    .name(notificationDto.getType())
                    .data(om.writeValueAsString(notificationDto)));
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (NullPointerException e) {
            System.out.println("사용자를 찾을 수 없음");
        }
    }
}
