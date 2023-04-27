package com.areastory.user.sse;

import com.areastory.user.dto.common.NotificationKafkaDto;
import lombok.Data;

import java.io.Serializable;

@Data
public class SseResponse implements Serializable {
    private String name;
    private NotificationKafkaDto data;
}
