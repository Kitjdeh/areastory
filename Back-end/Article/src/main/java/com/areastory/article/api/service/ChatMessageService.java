package com.areastory.article.api.service;

import com.areastory.article.dto.request.ChatMessageReq;
import com.areastory.article.dto.response.ChatMessageEnterResp;
import com.areastory.article.dto.response.ChatMessageQuitResp;
import com.areastory.article.dto.response.ChatMessageResp;
import com.areastory.article.dto.response.ChatRoomResp;
import org.springframework.data.domain.Pageable;

public interface ChatMessageService {

    ChatRoomResp findAllRoom(Long userId, Pageable pageable);


    ChatMessageResp saveMessage(ChatMessageReq messageDto);

    ChatMessageEnterResp enterRoom(ChatMessageReq messageDto);

    ChatMessageQuitResp outRoom(ChatMessageReq messageDto);
}
