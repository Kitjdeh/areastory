package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ChatRoomDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ChatRoomSupportRepository {
    Page<ChatRoomDto> findAllRoom(Long userId, Pageable pageable);
}
