package com.areastory.user.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

@Component
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResponseDefault {

    private int state;
    private boolean success;
    private String msg;
    private Object data;

    public ResponseEntity<?> success(Boolean success, String msg, Object data) {
        ResponseDefault responseDefault = ResponseDefault.builder()
                .state(HttpStatus.OK.value())
                .success(success)
                .msg(msg)
                .data(data)
                .build();
        return ResponseEntity.ok(responseDefault);
    }

    public ResponseEntity<?> fail(Boolean success, String msg, Object data) {
        ResponseDefault responseDefault = ResponseDefault.builder()
                .state(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .success(success)
                .msg(msg)
                .data(data)
                .build();
        return ResponseEntity.ok(responseDefault);
    }

    public ResponseEntity<?> notFound(Boolean success, String msg, Object data) {
        ResponseDefault responseDefault = ResponseDefault.builder()
                .state(HttpStatus.NOT_FOUND.value())
                .success(success)
                .msg(msg)
                .data(data)
                .build();
        return ResponseEntity.ok(responseDefault);
    }

}
