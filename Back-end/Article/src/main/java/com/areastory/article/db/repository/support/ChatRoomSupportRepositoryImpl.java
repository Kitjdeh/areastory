package com.areastory.article.db.repository.support;

import com.areastory.article.dto.common.ChatRoomDto;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.support.PageableExecutionUtils;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

import static com.areastory.article.db.entity.QChatRoom.chatRoom;
import static com.areastory.article.db.entity.QChatting.chatting;

@Repository
@RequiredArgsConstructor
public class ChatRoomSupportRepositoryImpl implements ChatRoomSupportRepository {

    private final JPAQueryFactory query;
//    private Map<String, ChatRoom> chatRoom;

//    private
//
//    @PostConstruct
//    private void init() {
//        chatRoom = new LinkedHashMap<>();
//    }


    @Override
    public Page<ChatRoomDto> findAllRoom(Long userId, Pageable pageable) {
        List<ChatRoomDto> chatRooms = query.select(Projections.constructor(ChatRoomDto.class,
                        chatRoom.roomId,
                        chatRoom.roomName,
                        chatRoom.userCount
                ))
                .from(chatRoom)
                .where(chatting.user.userId.eq(userId))
                .orderBy(getOrderSpecifier(pageable).toArray(OrderSpecifier[]::new))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        JPAQuery<Long> myChatList = query
                .select(chatting.count())
                .from(chatting)
                .where(chatting.user.userId.eq(userId));

        return PageableExecutionUtils.getPage(chatRooms, pageable, myChatList::fetchOne);
    }

    private List<OrderSpecifier> getOrderSpecifier(Pageable pageable) {
        List<OrderSpecifier> chatRoomOrders = new ArrayList<>();

        if (!pageable.getSort().isEmpty()) {
            for (Sort.Order order : pageable.getSort()) {
                Order direction = Order.DESC;
                if (order.getProperty().equals("createdAt")) {
                    chatRoomOrders.add(new OrderSpecifier<>(direction, chatRoom.lastChatDate));
                    chatRoomOrders.add(new OrderSpecifier<>(direction, chatRoom.roomName));
                }
            }
        }
        return chatRoomOrders;
    }
}
