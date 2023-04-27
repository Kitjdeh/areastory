package com.areastory.article;

import com.areastory.article.api.service.ArticleService;
import com.areastory.article.api.service.CommentService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ArticleApplicationTests {
    static {
        System.setProperty("com.amazonaws.sdk.disableEc2Metadata", "true");
    }

    @Autowired
    ArticleService articleService;
    @Autowired
    CommentService commentService;

    @Test
    void contextLoads() {
    }

}
