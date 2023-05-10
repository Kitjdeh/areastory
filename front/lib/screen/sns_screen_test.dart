import "package:flutter/material.dart";
import "package:front/component/sns/image_data.dart";
import "package:front/livechat/chat_screen.dart";

class SnsScreening extends StatefulWidget {
  final String userId;
  const SnsScreening({Key? key, required this.userId}) : super(key: key);

  @override
  State<SnsScreening> createState() => _SnsScreeningState();
}

Widget _storyBoardList() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
          100,
              (index) => Container(
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          )),
    ),
  );
}

class _SnsScreeningState extends State<SnsScreening> {
  late final userId = int.parse(widget.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LiveChatScreen(
                      userId: userId,
                      roomId: 'test',
                    )));
          },
          child: Image.asset(
            'asset/img/comment.png',
            height: 30,
          ),
        ),
        actions: [],
      ),
      body: ListView(
        children: [
          _storyBoardList(),
        ],
      ),
    );
  }
}