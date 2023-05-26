import 'package:flutter/material.dart';

class EnterOrQuit extends StatelessWidget {
  final String message;
  // final DateTime createdAt;

  const EnterOrQuit({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 30,
      ),
      child: SizedBox(
        height: 30,
        child: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
