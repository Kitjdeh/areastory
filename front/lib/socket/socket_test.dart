import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class LiveChatTest extends StatefulWidget {
  const LiveChatTest({Key? key}) : super(key: key);

  @override
  _LiveChatTestState createState() => _LiveChatTestState();
}

class _LiveChatTestState extends State<LiveChatTest> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <String>[];
  late final StompClient _stompClient;

  @override
  void initState() {
    super.initState();
    final _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.193.90:5002',
        onConnect: _onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print('1'),
        // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    _stompClient.activate();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _stompClient.deactivate();
    super.dispose();
  }

  void _onConnect(StompFrame frame) {
    print('2');
    _stompClient.subscribe(
      destination: '/sub/chat/room/1/ws',
      callback: (frame) {
        final message = json.decode(frame.body!)['message'];
        setState(() {
          _messages.add(message);
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _stompClient.send(
        destination: '/pub/chat/message/',
        body: json.encode({
          'message': message,
          'type': 'TALK',
          'roomId': 1,
          'sender': 1,
        }),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "행복한 소켓테스트 시간",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

        /// 앱바 그림자효과 제거
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Get.find<BottomNavController>().willPopAction();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(message),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
