package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ChatMessageService;
import com.areastory.article.db.entity.ChatMessage;
import com.areastory.article.db.entity.ChatRoom;
import com.areastory.article.db.repository.ChatMessageRepository;
import com.areastory.article.db.repository.ChatRoomRepository;
import com.areastory.article.dto.common.ChatMessageDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomRepository roomRepository;

    //채팅방의 정보들 => 추후 redis를 이용해 저장

    public List<ChatRoom> findAllRoom() {
        return roomRepository.findAll();
    }

    public ChatRoom findRoomById(String roomId) {
        return roomRepository.findByRoomId(roomId);
    }

    public boolean existRoom(String roomName) {
        return roomRepository.existsByRoomName(roomName);
    }

    public ChatRoom createRoom(String name) {
        return roomRepository.save(new ChatRoom(UUID.randomUUID().toString(), name));
    }

    public void save(ChatMessageDto message) {
        chatMessageRepository.save(ChatMessage.builder()
                .sender(message.getSender())
                .content(message.getContent())
                .roomeId(message.getRoomId())
                .build());
    }
}
