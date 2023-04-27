package com.areastory.user.sse;

import com.fasterxml.jackson.core.JsonProcessingException;
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

    private void send(Long userId, String name, SseResponse sseResponse) {
        String message;
        try {
            message = om.writeValueAsString(sseResponse);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        try {
            emitterMap.get(userId).send(SseEmitter.event()
                    .name(name)
                    .data(message));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
