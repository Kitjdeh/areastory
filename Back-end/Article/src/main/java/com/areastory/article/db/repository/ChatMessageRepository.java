package com.areastory.article.db.repository;

import com.areastory.article.db.entity.ChatMessage;
import com.areastory.article.db.repository.support.ChatMessageSupportRepository;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long>, ChatMessageSupportRepository {
}
