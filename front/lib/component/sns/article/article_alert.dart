import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  final String message;

  AlertModal({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('경고'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {  },
          child: Text('확인'),
        ),
      ],
    );
  }
}
