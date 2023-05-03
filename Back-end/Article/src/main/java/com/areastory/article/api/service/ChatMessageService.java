package com.areastory.article.api.service;

import com.areastory.article.dto.request.ChatMessageReq;
import com.areastory.article.dto.response.ChatMessageResp;
import com.areastory.article.dto.response.ChatRoomResp;
import org.springframework.data.domain.Pageable;

public interface ChatMessageService {

    ChatRoomResp findAllRoom(Long userId, Pageable pageable);


    ChatMessageResp saveMessage(ChatMessageReq messageDto);

    ChatMessageResp enterRoom(ChatMessageReq messageDto);

    ChatMessageResp outRoom(ChatMessageReq messageDto);
}
