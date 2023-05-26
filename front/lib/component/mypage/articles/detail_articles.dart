import 'package:flutter/material.dart';
import 'package:front/component/sns/post_widget.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({Key? key,
    required this.articleId,
    required this.userId,
    required this.followingId,}) : super(key: key);
  final int articleId;
  final int followingId;
  final int userId;

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}


class _AlbumDetailState extends State<AlbumDetail> {
  void onDelete(int articleId) {
    setState(() {});
  }

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
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "게시글 상세",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: ArticleComponent(
          userId: widget.userId,
          onDelete: onDelete,
          articleId: widget.articleId,
          followingId: widget.followingId,
          height: 300,
        ),
      ),
    );
  }
}
