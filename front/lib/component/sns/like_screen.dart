import 'package:flutter/material.dart';
import 'package:front/component/sns/comment/comment.dart';
import 'package:front/component/sns/like/like.dart';
import 'package:front/const/comment_test.dart';
import 'package:front/const/like_test.dart';

class SnsLikeScreen extends StatefulWidget {
  const SnsLikeScreen({Key? key}) : super(key: key);

  @override
  State<SnsLikeScreen> createState() => _SnsLikeScreenState();
}

class _SnsLikeScreenState extends State<SnsLikeScreen> {
  int _currentPage = 1;
  List _likes = [];
  final ScrollController _scrollController = ScrollController();

// void _loadMoreData() async {
  void _loadMoreData() async {
    // final newArticles = await api.fetchArticles(page: _currentPage + 1);
    // _articles.addAll(newArticles["articles"]);
    if (_currentPage == 1) {
      _likes.addAll(likeTest["likeList"]);
    } else if (_currentPage == 2) {
      _likes.addAll(likeTest2["likeList"]);
    } else if (_currentPage == 3) {
      _likes.addAll(likeTest2["likeList"]);
    }
    await _currentPage++;
    setState(() {
      // scrollToIndex(5);
    });
  }

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 100); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {
      print('성공!!!');
      print(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "좋아요",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

        /// 앱바 그림자효과 제거
        leading: IconButton(
          /// 뒤로가기버튼설정
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 3));
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _likes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _likes.length) {
                        return LikeComponent(
                          writer: _likes[index]["writer"],
                          writerProfile: _likes[index]["writerProfile"],
                          height: 100,
                          onUpdateIsChildActive: _updateIsChildActive,
                        );
                      } else {
                        _loadMoreData();
                        return Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return renderContainer(height: 3);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderContainer({
    double? height,
  }) {
    return Container(
      height: height,
    );
  }
}