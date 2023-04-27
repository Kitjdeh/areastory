import 'package:flutter/material.dart';

class MypageFollowScreen extends StatefulWidget {

  const MypageFollowScreen({Key? key}) : super(key: key);

  @override
  State<MypageFollowScreen> createState() => _MypageFollowScreenState();
}

class _MypageFollowScreenState extends State<MypageFollowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('감자'),
        ),
      ),
    );
  }
}
