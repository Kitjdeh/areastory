import 'package:flutter/material.dart';

class FollowScreen extends StatefulWidget {
  final ValueChanged<bool> onShowMyPageScreenChanged;

  const FollowScreen({required this.onShowMyPageScreenChanged ,Key? key}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            widget.onShowMyPageScreenChanged(true);
          },
          child: Text('감자'),
        ),
      ),
    );
  }
}
