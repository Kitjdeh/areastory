import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:front/api/comment/create_comment.dart';
import 'package:front/api/comment/get_comments.dart';
import 'package:front/component/sns/comment/comment.dart';

const List<String> list = <String>['인기순', '최신순'];

class SnsCommentScreen extends StatefulWidget {
  const SnsCommentScreen({Key? key, required this.index, required this.userId})
      : super(key: key);
  final String index;
  final String userId;

  @override
  State<SnsCommentScreen> createState() => _SnsCommentScreenState();
}

class _SnsCommentScreenState extends State<SnsCommentScreen> {
  int _currentPage = 1;
  int? _lastPage = 0;
  List _comments = [];
  String dropdownValue = list.first;

  final TextEditingController _commentController = TextEditingController();

  late final articleId = int.parse(widget.index);
  late final userId = int.parse(widget.userId);

  @override
  void initState() {
    super.initState();
    printComments();
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
    _currentPage = 1;
    _comments.clear();
    final commentData = await getComments(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'commentId',
      articleId: articleId,
      page: _currentPage,
    );
    _comments.addAll(commentData.comments);
    _lastPage = commentData.totalPageNumber;

    setState(() {});
  }

  void _loadMoreData() async {
    _currentPage++;
    final newComments = await getComments(
      sort: dropdownValue == '인기순' ? 'likeCount' : 'commentId',
      articleId: articleId,
      page: _currentPage,
    );
    _comments.addAll(newComments.comments);
    _lastPage = newComments.totalPageNumber;

    setState(() {
      // scrollToIndex(5);
    });
  }

  void createComment(content) async {
    await postComment(
      articleId: articleId,
      content: content,
    );

    final newComment = await getComments(
      articleId: articleId,
    );

    _comments.insert(0, newComment.comments.first);

    setState(() {});

    _commentController.clear();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToIndex(int index) {
    _scrollController.jumpTo(index * 100); // jumpTo 메서드를 사용하여 스크롤합니다.
  }

  void _updateIsChildActive(bool isChildActive) {
    setState(() {});
  }

  void onChangeSort(String dropdownValue) {
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
            Beamer.of(context).beamBack();
          },
        ),
        actions: [
          DropdownButton<String>(
            value: dropdownValue,
            style: const TextStyle(color: Colors.black),
            underline: null,
            autofocus: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onChanged: (String? value) {
              dropdownValue = value!;
              onChangeSort(value!);
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller:
                          _commentController, // TextEditingController setup
                      decoration: InputDecoration(
                        labelText: '댓글 입력',
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
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    printComments();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _comments.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < _comments.length) {
                        return CommentComponent(
                          myId: userId,
                          onDelete: onDelete,
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
