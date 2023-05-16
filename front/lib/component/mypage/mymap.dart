import 'package:flutter/material.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);

  @override
  State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print("마이페이지 지도돌아가용");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("지도")
            ],
          )
        ],
      ),
    );
  }
}
