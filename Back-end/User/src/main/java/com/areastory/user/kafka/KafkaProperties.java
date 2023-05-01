package com.areastory.user.kafka;

public interface KafkaProperties {
    String KAFKA_URL = "k8a3021.p.ssafy.io:9092";
    String TOPIC_NOTIFICATION = "notification";
    String TOPIC_ARTICLE = "server-article";
    String TOPIC_USER = "server-user";
    String TOPIC_FOLLOW = "follow";
    String TOPIC_LOG = "log-user";
    String GROUP_NAME_ARTICLE = "user-article";
    String GROUP_NAME_NOTIFICATION = "user-notification";
    String GROUP_NAME_USER_REPLY = "user-user-reply";
    String FOLLOW = "follow";
    String COMMENT = "comment";
    String ARTICLE_LIKE = "article-like";
    String COMMENT_LIKE = "comment-like";
    String USER_REPLY = "user-reply";
    String DELETE = "delete";
    String UPDATE = "update";
    String INSERT = "insert";
}
