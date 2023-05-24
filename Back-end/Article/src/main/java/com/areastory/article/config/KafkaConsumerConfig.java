package com.areastory.article.config;

import com.areastory.article.dto.common.FollowKafkaDto;
import com.areastory.article.dto.common.UserKafkaDto;
import com.areastory.article.kafka.KafkaProperties;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.LongDeserializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.KafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.listener.ConcurrentMessageListenerContainer;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class KafkaConsumerConfig {
    @Bean
    KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<Long, UserKafkaDto>>
    userContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<Long, UserKafkaDto> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(userConsumerFactory());
        factory.setConcurrency(1);
        factory.getContainerProperties().setPollTimeout(3000);
        return factory;
    }

    @Bean
    KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<Long, FollowKafkaDto>>
    followContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<Long, FollowKafkaDto> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(followConsumerFactory());
        factory.setConcurrency(1);
        factory.getContainerProperties().setPollTimeout(3000);
        return factory;
    }

    @Bean
    public ConsumerFactory<Long, UserKafkaDto> userConsumerFactory() {
        return new DefaultKafkaConsumerFactory<>(jsonConsumerConfigs(), new LongDeserializer(), new JsonDeserializer<>(UserKafkaDto.class, false));
    }

    @Bean
    public ConsumerFactory<Long, FollowKafkaDto> followConsumerFactory() {
        return new DefaultKafkaConsumerFactory<>(jsonConsumerConfigs(), new LongDeserializer(), new JsonDeserializer<>(FollowKafkaDto.class, false));
    }

    @Bean
    public Map<String, Object> jsonConsumerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaProperties.KAFKA_URL);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, JsonDeserializer.class);
        return props;
    }
}
