package com.areastory.user.db.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@MappedSuperclass
@EntityListeners(AutoCloseable.class)
@Data
public class ArticleBaseTime {

    @CreatedDate
    private LocalDateTime createdAt;

}
