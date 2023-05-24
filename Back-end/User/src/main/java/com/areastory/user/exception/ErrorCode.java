package com.areastory.user.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public enum ErrorCode {

    /* 400 BAD_REQUEST : 잘못된 요청 */
    /* 401 UNAUTHORIZED : 인증되지 않은 사용자 */
    UNAUTHORIZED_REQUEST(HttpStatus.UNAUTHORIZED, "권한 정보가 없습니다."),

    /* 404 NOT_FOUND : Resource를 찾을 수 없음 */
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."),
    ARTICLE_NOT_FOUND(HttpStatus.NOT_FOUND, "게시글을 찾을 수 없습니다."),
    COMMENT_NOT_FOUND(HttpStatus.NOT_FOUND, "댓글을 찾을 수 없습니다."),

    /* 409 : CONFLICT : Resource의 현재 상태와 충돌. 보통 중복된 데이터 존재 */
    DUPLICATE_RESOURCE(HttpStatus.CONFLICT, "이미 좋아요를 눌렀습니다."),
    LIKE_NOT_FOUND(HttpStatus.CONFLICT, "이미 취소가 되었습니다."),
    /* 500 Internal Server Error : 파일 변환 불가 */
    FAIL_CONVERT(HttpStatus.INTERNAL_SERVER_ERROR, "MultipartFile -> File로 전환이 실패했습니다."),

    /* 파일 삭제 불가 부분 에러 코드 생각해봐야함*/
    FILE_NOT_FOUND(HttpStatus.NOT_FOUND, "파일 삭제 불가"),

    HEADER_ERROR(HttpStatus.BAD_REQUEST, "입력 실패");


    private final HttpStatus httpStatus;
    private final String message;
}