package com.areastory.article.api.service.impl;

import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Configuration;

@SpringBootTest
@Configuration
@Order(2)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class) // @Order 에 의해서 실행 순서 결정
public class CommentServiceImplTest {
}
