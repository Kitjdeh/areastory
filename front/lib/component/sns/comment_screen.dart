import 'package:flutter/material.dart';
import 'package:front/api/comment/create_comment.dart';
import 'package:front/api/comment/get_comments.dart';
import 'package:front/component/sns/comment/comment.dart';
import 'package:front/constant/home_tabs.dart';
import 'package:front/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class SnsCommentScreen extends StatefulWidget {
  const SnsCommentScreen({
    Key? key,
    required this.articleId,
    required this.userId,
  }) : super(key: key);
  final int articleId;
  final int userId;

  @override
  State<SnsCommentScreen> createState() => _SnsCommentScreenState();
}

class _SnsCommentScreenState extends State<SnsCommentScreen> {
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  List _comments = [];
  String dropdownValue = '인기순';

  final TextEditingController _commentController = TextEditingController();
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    printComments();
    _controller.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void onDelete(int commentId) async {
    setState(() {});
  }

  void printComments() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    _currentPage = 1;
    _comments.clear();
    final commentData = await getComments(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'commentId',
      articleId: widget.articleId,
      page: _currentPage,
    );
    _comments.addAll(commentData.comments);
    _hasNextPage = commentData.nextPage;

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMoreData() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 3000)
      setState(() {
        _isLoadMoreRunning = true;
      });
    _currentPage += 1;
    final newComments = await getComments(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'commentId',
      articleId: widget.articleId,
      page: _currentPage,
    );
    _comments.addAll(newComments.comments);
    _hasNextPage = newComments.nextPage;

    setState(() {
      print('성공');
      _isLoadMoreRunning = false;
    });
  }

  void createComment(content) async {
    await postComment(
      articleId: widget.articleId,
      content: content,
    );

    final newComment = await getComments(
      articleId: widget.articleId,
    );

    _comments.insert(0, newComment.comments.first);

    setState(() {});

    _commentController.clear();
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {});
  }

  void onChangeSort(String dropdownValue) {
    this.dropdownValue = dropdownValue;
    setState(() {
      printComments();
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
        actions: [
          GestureDetector(
            onTap: () {
              dropdownValue == '인기순'
                  ? onChangeSort('최신순')
                  : onChangeSort('인기순');
            },
            child: ImageData(
              dropdownValue == '인기순' ? IconsPath.hot : IconsPath.recently,
              width: 250,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    printComments();
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          _comments.length,
                          (index) => CommentComponent(
                            myId: widget.userId,
                            onDelete: onDelete,
                            commentId: _comments[index].commentId,
                            articleId: _comments[index].articleId,
                            userId: _comments[index].userId,
                            height: 100,
                            onUpdateIsChildActive: _updateIsChildActive,
                          ),
                        ),
                      ),
                      if (_isLoadMoreRunning)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (!_isLoadMoreRunning && !_hasNextPage)
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          child: const Center(
                            child: Text('더이상 댓글이 없습니다'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller:
                          _commentController, // TextEditingController setup
                      decoration: InputDecoration(
                        labelText: '댓글 입력',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final value = _commentController
                        .text; // Get the value from the TextEditingController
                    createComment(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
