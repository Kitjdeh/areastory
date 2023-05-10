package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ChatMessageDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.areastory.article.db.entity.QChatMessage.chatMessage;

@Repository
@RequiredArgsConstructor
public class ChatMessageSupportRepositoryImpl implements ChatMessageSupportRepository {
    private final JPAQueryFactory query;

    @Override
    public List<ChatMessageDto> findByRoomId(String roomId) {
        return query.select(Projections.constructor(ChatMessageDto.class,
                        chatMessage.user.userId,
                        chatMessage.user.nickname,
                        chatMessage.user.profile,
                        chatMessage.content
                ))
                .from(chatMessage)
                .where(chatMessage.chatRoom.roomId.eq(roomId))
                .orderBy(chatMessage.createdAt.asc())
                .limit(200L)
                .fetch();
    }
}
