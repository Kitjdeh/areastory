import 'package:flutter/material.dart';

class FollowMapScreen extends StatefulWidget {
  const FollowMapScreen({Key? key}) : super(key: key);

  @override
  State<FollowMapScreen> createState() => _FollowMapScreenState();
}

class _FollowMapScreenState extends State<FollowMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("팔로우 지도입니당!")
            ],
          )
        ],
      ),
    );
  }
}
