import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  final String message;

  AlertModal({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('게시물 없음'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}
