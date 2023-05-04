package com.areastory.article.config;

import com.areastory.article.dto.common.ArticleKafkaDto;
import com.areastory.article.kafka.KafkaProperties;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.LongSerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class KafkaProducerConfig {
    @Bean
    public ObjectMapper getObjectMapper() {
        return new ObjectMapper();
    }

    @Bean
    public ProducerFactory<Long, ArticleKafkaDto> articleProducerFactory() {
        return new DefaultKafkaProducerFactory<>(articleProducerConfig());
    }

    @Bean
    public KafkaTemplate<Long, ArticleKafkaDto> articleTemplate() {
        return new KafkaTemplate<>(articleProducerFactory());
    }

    @Bean
    public ProducerFactory<Long, String> notificationProducerFactory() {
        return new DefaultKafkaProducerFactory<>(notificationProducerConfig());
    }

    @Bean
    public KafkaTemplate<Long, String> notificationTemplate() {
        return new KafkaTemplate<>(notificationProducerFactory());
    }

    @Bean
    public ProducerFactory<Long, Long> userReplyProducerFactory() {
        return new DefaultKafkaProducerFactory<>(userReplyProducerConfig());
    }

    @Bean
    public KafkaTemplate<Long, Long> userReplyTemplate() {
        return new KafkaTemplate<>(userReplyProducerFactory());
    }

    @Bean
    public Map<String, Object> notificationProducerConfig() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaProperties.KAFKA_URL);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        return props;
    }

    @Bean
    public Map<String, Object> userReplyProducerConfig() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaProperties.KAFKA_URL);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
        return props;
    }

    @Bean
    public Map<String, Object> articleProducerConfig() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaProperties.KAFKA_URL);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        return props;
    }
}
