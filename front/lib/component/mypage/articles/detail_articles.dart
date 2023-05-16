import 'package:flutter/material.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({Key? key, required this.articleId}) : super(key: key);
  final int articleId;

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            // Get.find<BottomNavController>().willPopAction();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Text("감자"),
    );
  }
}
