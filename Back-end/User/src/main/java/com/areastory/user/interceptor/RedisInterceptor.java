//package com.areastory.user.interceptor;
//
//import com.areastory.user.exception.CustomException;
//import com.areastory.user.exception.ErrorCode;
//import lombok.RequiredArgsConstructor;
//import org.springframework.data.redis.core.RedisTemplate;
//import org.springframework.stereotype.Component;
//import org.springframework.util.StringUtils;
//import org.springframework.web.servlet.HandlerInterceptor;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.util.Set;
//
//@Component
//@RequiredArgsConstructor
//public class RedisInterceptor implements HandlerInterceptor {
//
//    private final RedisTemplate<String, String> redisTemplate;
//
//    @Override
//    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//        String userId = request.getHeader("userId");
//        String hashKey = request.getHeader("hashKey");
//
//        if (StringUtils.isEmpty(userId) || StringUtils.isEmpty(hashKey)) {
//            throw new CustomException(ErrorCode.HEADER_ERROR);
//        }
//
//        Set<String> keys = redisTemplate.keys("*");
//        if (keys.contains(userId)) {
//            String value = redisTemplate.opsForValue().get(userId);
//            if (value != null && value != "" && value.equals(hashKey)) {
//                return true;
//            }
//            throw new CustomException(ErrorCode.UNAUTHORIZED_REQUEST);
//        }
//        throw new CustomException(ErrorCode.USER_NOT_FOUND);
//    }
//}
