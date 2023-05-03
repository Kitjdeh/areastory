package com.areastory.article.api.service;

import com.areastory.article.db.entity.ChatRoom;
import com.areastory.article.dto.common.ChatMessageDto;

import java.util.List;

public interface ChatMessageService {

    List<ChatRoom> findAllRoom();

    ChatRoom findRoomById(String roomId);

    boolean existRoom(String roomName);

    ChatRoom createRoom(String name);

    void save(ChatMessageDto message);
}
