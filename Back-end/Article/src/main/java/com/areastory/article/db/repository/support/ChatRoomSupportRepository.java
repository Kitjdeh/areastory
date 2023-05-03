package com.areastory.article.db.repository.support;

import com.areastory.article.db.entity.ChatRoom;

import java.util.List;

public interface ChatRoomSupportRepository {
    List<ChatRoom> findAllRoom();
}
