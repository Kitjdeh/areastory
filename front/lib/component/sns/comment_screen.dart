import 'package:flutter/material.dart';
import 'package:front/api/comment/get_comments.dart';
import 'package:front/component/sns/comment/comment.dart';
import 'package:front/const/comment_test.dart';

class SnsCommentScreen extends StatefulWidget {
  const SnsCommentScreen({Key? key, required this.index}) : super(key: key);
  final String index;

  @override
  State<SnsCommentScreen> createState() => _SnsCommentScreenState();
}

class _SnsCommentScreenState extends State<SnsCommentScreen> {
  int _currentPage = 1;
  int? _lastPage = 0;
  List _comments = [];

  late final articleId = int.parse(widget.index);

  @override
  void initState() {
    super.initState();
    printComments();
  }

  void printComments() async {
    final commentData = await getComments(
      articleId: articleId,
    );
    _comments.addAll(commentData.comments);
    _lastPage = commentData.totalPageNumber;
  }

  void _loadMoreData() async {
    final newComments = await getComments(
      articleId: articleId,
    );
    _comments.addAll(newComments.comments);
    _currentPage++;

    setState(() {
      // scrollToIndex(5);
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 100); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {});
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
                          commentId: _comments[index].commentId,
                          articleId: _comments[index].articleId,
                          userId: _comments[index].userId,
                          nickname: _comments[index].nickname,
                          profile: _comments[index].profile,
                          content: _comments[index].content,
                          likeCount: _comments[index].likeCount,
                          likeYn: _comments[index].likeYn,
                          createdAt: _comments[index].createdAt,
                          height: 100,
                          onUpdateIsChildActive: _updateIsChildActive,
                        );
                      } else if (_currentPage < _lastPage!) {
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
