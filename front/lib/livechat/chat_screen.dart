import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/component/sns/avatar_widget.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/livechat/chat.dart';
import 'package:front/livechat/enter_or_quit.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class LiveChatScreen extends StatefulWidget {
  final int userId;
  final String roomId;
  final String roomName;
  final String? profile;

  const LiveChatScreen({
    Key? key,
    required this.userId,
    required this.roomId,
    required this.roomName,
    this.profile,
  }) : super(key: key);

  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = [];
  late final StompClient _stompClient;
  late final myId;
  bool _connected = false;
  int userCount = 0;
  bool? textYn = false;

  @override
  void initState() {
    super.initState();
    final stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://k8a302.p.ssafy.io/ws-chat',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    _stompClient = stompClient;
    stompClient.activate();
    goMyId();
  }

  void goMyId() async {
    final storage = FlutterSecureStorage();
    myId = await storage.read(key: 'userId');
  }

  void onConnect(StompFrame frame) {
    print('연결됨');
    _stompClient.subscribe(
      destination: '/sub/chat/room/${widget.roomId}',
      callback: (frame) async {
        final dynamic message = json.decode(frame.body!);
        // print(message["userCount"]);
        // print(message);
        setState(() {
          if (message.containsKey('messageList')) {
            if (message["userId"] == widget.userId) {
              _messages.addAll(message["messageList"]);
            }
            userCount = message["userCount"];
            _messages.add({"message": message["message"]});
          } else if (message.containsKey('message')) {
            _messages.add({"message": message["message"]});
            userCount = message["userCount"];
          } else {
            _messages.add(message);
          }
        });
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      },
    );

    _stompClient.send(
      destination: '/pub/chat/message',
      body: json.encode({
        'content': '',
        'type': 'ENTER',
        'roomId': widget.roomId,
        'userId': widget.userId,
      }),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    print(message);
    if (message.isNotEmpty) {
      _stompClient.send(
        destination: '/pub/chat/message',
        body: json.encode({
          'content': message,
          'type': 'TALK',
          'roomId': widget.roomId,
          'userId': widget.userId,
        }),
      );
      _messageController.clear();
    }
    setState(() {
      textYn = false;
    });
  }

  void _disconnect() {
    if (_connected) {
      // 구독 취소 및 연결 끊기 전에 서버에게 나간다는 신호 전달
      _stompClient.send(
        destination: '/pub/chat/message',
        body: json.encode({
          'content': '',
          'type': 'QUIT',
          'roomId': widget.roomId,
          'userId': widget.userId,
        }),
      );
      print('연결 끊음1');
      _stompClient.deactivate();
      setState(() {
        _connected = false; // 연결 상태 업데이트
        _messages.clear(); // 메시지 클리어
      });
    }
  }

  @override
  void dispose() {
    print('연결 끊음2');
    _stompClient.send(
      destination: '/pub/chat/message',
      body: json.encode({
        'content': '',
        'type': 'QUIT',
        'roomId': widget.roomId,
        'userId': widget.userId,
      }),
    );
    _connected = false;
    _messages.clear();
    _stompClient.deactivate();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.roomName} (참가인원:${userCount})",
          // "${widget.roomId}의 STORY",
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
            _disconnect();
            Navigator.of(context).pop();
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
                return _messages[index].length == 1
                    ? EnterOrQuit(
                        message: _messages[index]["message"],
                      )
                    : ChatComponent(
                        profile: _messages[index]["profile"],
                        nickname: _messages[index]["nickname"],
                        content: _messages[index]["content"],
                        // createdAt: _messages[index]["createdAt"],
                        userId: _messages[index]["userId"],
                        myId: myId,
                        height: 80,
                      );
              },
            ),
          ),
          Row(
            children: [
              AvatarWidget(
                type: AvatarType.TYPE1,
                thumbPath: widget.profile!,
                size: 30,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '이야기를 작성해주세요',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        textYn = value.isNotEmpty;
                      });
                    },
                    maxLines: null, // maxLines 속성 제거
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  textYn! ? _sendMessage() : print('작성해줘');
                },
                child: textYn!
                    ? ImageData(
                        IconsPath.go,
                        width: 100,
                      )
                    : ImageData(
                        IconsPath.stop,
                        width: 100,
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
