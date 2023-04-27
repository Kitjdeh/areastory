package com.areastory.article.kafka;

public interface KafkaProperties {

    String TOPIC_NOTIFICATION = "notification";
    String TOPIC_ARTICLE = "server-article";
    String TOPIC_USER = "server-user";
    String GROUP_NAME = "map";
    String COMMENT = "comment";
    String ARTICLE_LIKE = "article-like";
    String COMMENT_LIKE = "comment-like";
    String TOPIC_LOG = "log-article";
    String KAFKA_URL = "k8a3021.p.ssafy.io:9092";
    String DELETE = "delete";
    String UPDATE = "update";
    String INSERT = "insert";
    String USER_REPLY = "user-reply";
}
