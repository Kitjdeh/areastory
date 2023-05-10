//package com.areastory.user.config;
//
//import com.areastory.user.interceptor.RedisInterceptor;
//import lombok.RequiredArgsConstructor;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
//import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//
//@Configuration
//@RequiredArgsConstructor
//public class WebMvcConfiguration implements WebMvcConfigurer {
//
//    private final RedisInterceptor redisInterceptor;
//
//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(redisInterceptor)
//                .addPathPatterns("/api/**")
//                .excludePathPatterns("/api/users/login", "/api/users/sign-up");
//    }
//}
