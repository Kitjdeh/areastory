package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ChatMessageDto;

import java.util.List;

public interface ChatMessageSupportRepository {

    List<ChatMessageDto> findByRoomId(String roomId);
}
