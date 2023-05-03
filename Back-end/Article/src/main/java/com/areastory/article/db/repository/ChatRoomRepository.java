package com.areastory.article.db.repository;

import com.areastory.article.db.entity.ChatRoom;
import com.areastory.article.db.repository.support.ChatRoomSupportRepository;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long>, ChatRoomSupportRepository {
    ChatRoom findByRoomId(String roomId);

    boolean existsByRoomName(String name);
}
