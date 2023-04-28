import 'package:flutter/material.dart';

class SnsCommentScreen extends StatefulWidget {
  const SnsCommentScreen({Key? key}) : super(key: key);

  @override
  State<SnsCommentScreen> createState() => _SnsCommentScreenState();
}

class _SnsCommentScreenState extends State<SnsCommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('댓글 페이지인데 뒤로 가려면 눌러'),
        ),
      ),
    );
  }
}
