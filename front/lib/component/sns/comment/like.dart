import 'package:flutter/material.dart';

class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key}) : super(key: key);

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('좋아요 누른 사람들!!'),
        ),
      ),
    );
  }
}
