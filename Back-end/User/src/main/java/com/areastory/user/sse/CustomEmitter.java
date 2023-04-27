package com.areastory.user.sse;

import lombok.Getter;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Getter
public class CustomEmitter extends SseEmitter {
    private final Long userId;

    public CustomEmitter(Long userId, Long timeout) {
        super(timeout);
        this.userId = userId;
    }

}
