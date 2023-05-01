import 'package:flutter/material.dart';
import 'package:front/component/sns/comment/comment.dart';
import 'package:front/const/comment_test.dart';

class SnsCommentScreen extends StatefulWidget {
  const SnsCommentScreen({Key? key}) : super(key: key);

  @override
  State<SnsCommentScreen> createState() => _SnsCommentScreenState();
}

class _SnsCommentScreenState extends State<SnsCommentScreen> {
  int _currentPage = 1;
  List _comments = [];
  final ScrollController _scrollController = ScrollController();

// void _loadMoreData() async {
  void _loadMoreData() async {
    // final newArticles = await api.fetchArticles(page: _currentPage + 1);
    // _articles.addAll(newArticles["articles"]);
    if (_currentPage == 1) {
      _comments.addAll(commentTest["commentList"]);
    } else if (_currentPage == 2) {
      _comments.addAll(commentTest2["commentList"]);
    } else if (_currentPage == 3) {
      _comments.addAll(commentTest2["commentList"]);
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
          "댓글",
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
                    itemCount: _comments.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _comments.length) {
                        return CommentComponent(
                          writer: _comments[index]["writer"],
                          writerProfile: _comments[index]["writerProfile"],
                          content: _comments[index]["content"],
                          likeCount: _comments[index]["likeCount"],
                          isLike: _comments[index]["isLike"],
                          createdAt: _comments[index]["createdAt"],
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
