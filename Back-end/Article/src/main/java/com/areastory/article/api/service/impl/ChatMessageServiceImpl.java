package com.areastory.article.api.service.impl;

import com.areastory.article.api.service.ChatMessageService;
import com.areastory.article.db.entity.ChatMessage;
import com.areastory.article.db.entity.ChatRoom;
import com.areastory.article.db.entity.User;
import com.areastory.article.db.repository.ChatMessageRepository;
import com.areastory.article.db.repository.ChatRoomRepository;
import com.areastory.article.db.repository.UserRepository;
import com.areastory.article.dto.common.ChatMessageDto;
import com.areastory.article.dto.common.ChatRoomDto;
import com.areastory.article.dto.request.ChatMessageReq;
import com.areastory.article.dto.response.ChatMessageResp;
import com.areastory.article.dto.response.ChatRoomResp;
import com.areastory.article.exception.CustomException;
import com.areastory.article.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomRepository chatRoomRepository;
    private final UserRepository userRepository;

    //채팅방의 정보들 => DB에 더미데이터로 저장

    public ChatRoomResp findAllRoom(Long userId, Pageable pageable) {
        Page<ChatRoomDto> chatRooms = chatRoomRepository.findAllRoom(userId, pageable);
        return ChatRoomResp.builder()
                .chatRoomList(chatRooms.getContent())
                .pageSize(chatRooms.getPageable().getPageSize())
                .totalPageNumber(chatRooms.getTotalPages())
                .totalCount(chatRooms.getTotalElements())
                .pageNumber(chatRooms.getPageable().getPageNumber() + 1)
                .nextPage(chatRooms.hasNext())
                .previousPage(chatRooms.hasPrevious())
                .build();
    }

    public ChatMessageResp saveMessage(ChatMessageReq messageReq) {
        User user = userRepository.findById(messageReq.getUserId())
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        //채팅 내역 저장
        chatMessageRepository.save(ChatMessage.builder()
                .chatRoom(chatRoomRepository.findByRoomId(messageReq.getRoomId()))
                .user(user)
                .content(messageReq.getContent())
                .build());

        //채팅방 시간 업데이트
        chatRoomRepository.findByRoomId(messageReq.getRoomId()).updateLastChatDate();

        //최신 200개 대화 내용 불러오기
        List<ChatMessageDto> messageList = chatMessageRepository.findByRoomId(messageReq.getRoomId());
        return ChatMessageResp.builder()
                .type(messageReq.getType())
                .userId(messageReq.getUserId())
                .profile(user.getProfile())
                .nickname(user.getNickname())
                .messageList(messageList)
                .userCount(chatRoomRepository.findByRoomId(messageReq.getRoomId()).getUserCount())
                .build();
    }

    @Override
    public ChatMessageResp enterRoom(ChatMessageReq messageReq) {
        User user = userRepository.findById(messageReq.getUserId())
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        //방인원수 증가
        ChatRoom chatRoom = chatRoomRepository.findByRoomId(messageReq.getRoomId());
        chatRoom.updateUserCount();
        return ChatMessageResp.builder()
                .type(messageReq.getType())
                .userId(messageReq.getUserId())
                .profile(user.getProfile())
                .nickname(user.getNickname())
                .messageList(chatMessageRepository.findByRoomId(messageReq.getRoomId()))
                .userCount(chatRoom.getUserCount())
                .build();
    }

    @Override
    public ChatMessageResp outRoom(ChatMessageReq messageReq) {
        User user = userRepository.findById(messageReq.getUserId())
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));
        //방인원수 감소
        ChatRoom chatRoom = chatRoomRepository.findByRoomId(messageReq.getRoomId());
        chatRoom.deleteUserCount();
        return ChatMessageResp.builder()
                .type(messageReq.getType())
                .userId(messageReq.getUserId())
                .profile(user.getProfile())
                .nickname(user.getNickname())
                .userCount(chatRoom.getUserCount())
                .build();
    }


}
